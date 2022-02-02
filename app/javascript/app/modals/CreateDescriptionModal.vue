<template>
  <div v-if="word" class="ls-modal">
    <form class="ls-modal-form form-inline">
      <div class="ls-modal-header">
        <div class="title">Novo Enunciado</div>
      </div>
      <div class="ls-modal-content">
        <div v-if="word" class="fields">
          <div class="form-group" :class="{ 'has-error': errors.text }">
            <slot name="word" :word="word">
              <label class="is-sentence"> Texto: </label>
              <span class="input">
                <textarea v-model="word.text" class="form-control" rows="5" />
              </span>
            </slot>
            <p v-if="errors.text" class="text-danger feedback">
              Campo Obrigatório *
            </p>
          </div>
          <div
            v-if="audioVisible"
            class="form-group"
            :class="{ 'has-error': errors.audio }"
          >
            <label>Audio:</label>
            <span class="input">
              <ls-input-file
                v-model="audio.attachment"
                :placeholder="audioPlaceholder"
                :invalid="errors.audio"
                accept="audio/mp3,audio/mpeg"
              >
                <i class="icon icon-upload-solid"></i> Selecionar Arquivo
              </ls-input-file>
            </span>
          </div>
        </div>
      </div>
      <div class="ls-modal-footer">
        <button
          @click="close"
          type="button"
          class="btn btn-default"
          :disabled="busy"
        >
          Cancelar
        </button>

        <button
          @click="submit"
          type="button"
          class="btn btn-primary"
          :disabled="busy"
        >
          Salvar
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import Vue from 'vue'
import { values, omit } from 'lodash'
import objectToFormData from 'object-to-formdata'
import ActiveRecordHelper from '../utils/activerecord'
import Word from '../models/Word'
import { WordTypes } from '../types'

const permittedTypes = [
  'substantivo_proprio',
  'substantivo_comum',
  'frase',
  'texto',
  'input_custom'
]

const unpermitted_params = [
  'id',
  'total_syllables',
  'syllables',
  'info',
  'images'
]

export default {
  props: {
    text: {
      type: String,
      default: null
    },
    embedded: {
      type: Boolean,
      default: false
    },
    audioRequired: {
      type: Boolean,
      default: true
    },
    audioVisible: {
      type: Boolean,
      default: true
    },
    isEditing: {
      type: Boolean,
      default: false
    },
    wordId: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      word: null,
      audio: {},
      image: {},
      errors: {},
      busy: false,
      description: ''
    }
  },
  computed: {
    types() {
      return values(WordTypes).filter(type => permittedTypes.includes(type.key))
    },
    hasError() {
      return values(this.errors).some(bool => bool)
    },
    audioPlaceholder() {
      if (this.isEditing) {
        return this.word.audios.length ? this.word.audios[0].url : ''
      }
      return ''
    }
  },
  created() {
    if (this.isEditing || this.word) {
      return true
    }
    const word = new Word()

    word.text = this.text
    Vue.set(this, 'word', word)
  },
  methods: {
    async submit() {
      this.validates()

      this.busy = true

      if (this.hasError) {
        this.busy = false
        this.$notify({
          group: 'danger',
          title: 'Falha na Validação',
          text: 'Por favor verifique no formulário a causa e o motivo'
        })
        return { error: true }
      }

      const payload = this.mapWord()

      const dataForm = {
        question_description: {
          text: payload.word.text,
          audio: payload.word.audios_attributes[0]?.attachment
        }
      }

      dataForm.question_description = omit(
        dataForm.question_description,
        unpermitted_params
      )

      const formBody = objectToFormData(dataForm, { indices: true })

      try {
        const data = await this.$axios({
          url: 'descriptions.json',
          method: 'post',
          data: formBody,
          headers: { 'Content-Type': 'multipart/form-data' }
        })

        if (data.errors) {
          const message = ActiveRecordHelper.errorMessage(data.errors)
          throw new Error(message)
        }

        this.$notify({
          group: 'success',
          title: 'Sucesso',
          text: 'Nova descrição criada com sucesso!'
        })

        this.$emit('close', data.data)

        return { data }
      } catch (error) {
        if (this.embedded) {
          throw new Error(error)
        } else {
          this.$notify({
            group: 'danger',
            title: 'Falha na Validação',
            text: error.message
          })
        }
        this.busy = false
        return { error: true, data: error }
      }
    },
    validates() {
      const errors = {}
      errors.text = !this.word.text
      //errors.audio = this.validateAudio()
      Vue.set(this, 'errors', errors)
    },
    validateAudio() {
      let invalid = false

      if (this.audioRequired) {
        if (invalid) {
          invalid = !this.audio.attachment
        }
        return invalid
      }

      if (this.isSubstantivoProprio) {
        return false
      }

      return !this.audio.attachment
    },
    close() {
      this.$emit('close', false)
    },
    mapWord() {
      let payload = { word: { ...this.word } }

      if (this.audio.attachment) {
        if (this.isEditing) {
          payload.word.audios_attributes = []

          payload.word.audios_attributes.push(omit(this.audio, ['url']))

          if (this.word.audios.length) {
            this.word.audios.forEach(a => {
              payload.word.audios_attributes.push({ id: a.id, _destroy: '1' })
            })
          }
        } else {
          payload.word.audios_attributes = [omit(this.audio, ['url'])]
        }
      }

      return payload
    }
  },
  watch: {
    async wordId(word_id) {
      if (this.isEditing && word_id) {
        let { data } = await this.$axios.get(`/words/${word_id}.json`)
        // map word
        this.$set(this, 'word', data)
      }
    }
  }
}
</script>

<style lang="scss">
.ls-modal {
  &-header {
    @include nunito_bold;
    background-color: $brand-primary;
    border-bottom: 1px solid $brand-primary;
    padding: $gap * 1.5;
    text-align: center;
    .title {
      font-size: 18px;
      color: white;
      text-transform: uppercase;
    }
  }
  &-footer {
    display: flex;
    justify-content: flex-end;
    padding: $gap ($gap * 2);
    border-top: 1px solid $border-color;
    .btn {
      margin: 0px $gap;
    }
  }
  &-content {
    max-height: 50vh;
    min-height: 200px;
    overflow-x: hidden;
    overflow-y: auto;
    padding: ($gap * 4) ($gap * 2.5);
  }
  &-form {
    .form-group {
      display: flex;
      flex-wrap: wrap;
      box-sizing: border-box;
      width: 100%;
      margin-bottom: $gap * 3;
      .feedback {
        display: block;
        width: 100%;
        margin-top: 4px;
        margin-left: 20%;
        font-size: 10px;
      }
      label {
        max-width: 20%;
        flex: 1;
        padding: 0px ($gap * 2);
        align-self: center;
        text-align: right;
        &.is-sentence {
          align-self: flex-start;
        }
      }

      .input {
        flex: 2;
        display: inline-block;
        width: 100%;
        .ls-input-syllables,
        .ls-input-number-syllables {
          padding: 0px;
        }
        .form-control,
        select,
        .input-file {
          width: 100%;
          max-width: 100%;
        }
      }
    }
  }
  &.is-embedded {
    .ls-modal-header,
    .ls-modal-footer {
      display: none;
    }
    .ls-modal-content {
      padding: 0px;
      max-height: none;
      min-height: 0px;
    }
    .ls-modal-form {
      .form-group {
        label {
          flex: 1;
          text-align: left;
          padding: 0;
        }
        .input {
          flex: 3;
        }
      }
    }
  }
}
</style>
