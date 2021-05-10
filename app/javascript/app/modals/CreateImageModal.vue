<template>
<div v-if="word" class="ls-modal" :class="{'is-embedded': embedded}">
  <form class="ls-modal-form form-inline">
    
    <div class="ls-modal-content">        
        <div v-if="word && word.type" class="fields">
          <div class="form-group" :class="{'has-error': errors.image}">
            <label>{{label}}</label>
            <span class="input">
              <ls-input-file 
                v-model="image.attachment" 
                :placeholder="imagePlaceholder"
                :invalid="errors.image" 
                accept="image/*"
              >
                <i class="icon icon-upload-solid"></i> Selecionar Arquivo
              </ls-input-file>
            </span>
            <p v-if="errors.image" class="text-danger feedback">
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
import { clone, values, find, omit } from 'lodash'
import objectToFormData from 'object-to-formdata'
import { WordTypes } from '../types'
import ActiveRecordHelper from '../utils/activerecord'
import Word from '../models/Word'

const unpermitted_params = [
  'id', 
  'total_syllables', 
  'syllables', 
  'info', 
  'images', 
  'audios'
]

export default {
  props: {
    text: {
      type: String,
      default: null
    },
    label: {
      type: String,
      default: ""
    },
    embedded: {
      type: Boolean,
      default: false
    },
    wordType: {
      type: Number,
      default: null
    },
    audioRequired: {
      type: Boolean,
      default: false,
    },
    audioVisible: {
      type: Boolean,
      default: false,
    },
    imageRequired: {
      type: Boolean,
      default: false
    },
    isEditing: {
      type: Boolean,
      default: false
    },
    isNotEmpty: {
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
      image: {},
      audio: {},
      errors: {},
      busy: false
    }
  },
  computed: {
    hasError() {
      return values(this.errors).some(bool => bool)
    },
    imagePlaceholder() {
      if (this.isNotEmpty) {
        return 'imagem-selecionada'
      } else if (this.isEditing) {
        return this.word.images.length ? this.word.images[0].url : ''
      }
      return ''
    },
    audioPlaceholder() {
       if (this.isNotEmpty) {
        return 'audio-selecionado'
      } else if (this.isEditing) {
        return this.word.audios.length ? this.word.audios[0].url : "";
      }
      return "";
    },
  },
  created(){
    if (this.isEditing  || this.word) {
      return true
    }
    
    const word = new Word()

    if(this.wordType) {
      word.type = this.wordType
    }

    Vue.set(this, 'word', word)
  },
  methods: {
    async submit() {

      this.validates()
      this.busy = true

      if (this.hasError) {
        this.busy = false
        return { error: true }
      }
      
      const payload = this.mapWord()
      //----------- Solução temporária
      const letters = '0123456789ABCDEFGHIJKLMNOPQRSTUVXZ'
      let prefix = 'INPUT-'
      for (let i = 0; i < 10; i++) {
        prefix += letters[Math.floor(Math.random() * 33)]        
      }   
      payload.word.text = prefix
      //------------------------------------
  
      const formBody = objectToFormData(payload, { indices: true })

      try {      
        const { data } = await this.$axios({
          url: this.isEditing ? `/words/${this.wordId}.json` : '/words.json',
          method: this.isEditing ? 'put' : 'post',
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
          text: 'Nova Imagem criada com sucesso!'
        })
        
       this.$emit('close', data)        
  
        return { data }
      } catch (error) {
        if (this.embedded) {
          throw new Error(error)
        } else {
        }

        this.busy = false

        return { error: true, data: error }
      }
    },
    validates() {     
      const errors = {}
      errors.image = !this.image.attachment

      Vue.set(this, 'errors', errors)
    },
    close() {
      this.$emit('close', false)
    },
    validateAudio() {
      let invalid = false;

      if (this.audioRequired) {
        if (invalid) {
          invalid = !this.audio.attachment;
        }
        return invalid;
      }

      if (this.isSubstantivoProprio) {
        return false;
      }

      return this.isLong ? false : !this.audio.attachment;
    },

    mapWord() {
      let payload = { 
        word: { 
            audios_attributes: [],
            images_attributes: [],
            type: "input_text",
            text: ''
          } 
        }
       const types = values(WordTypes)
      
      if (this.image.attachment) {
        if (this.isEditing) {
          payload.word.images_attributes = []
          
          payload.word.images_attributes.push(
            omit(this.image, ['url'])
          )

          if (this.word.images.length) {
            this.word.images.forEach(i => {
              payload.word.images_attributes.push(
                { id:  i.id, _destroy: '1' }
              )
            })            
          }
        } else {
          payload.word.images_attributes = [ 
            omit(this.image, ['url'])
          ]
        }
      }

      if (this.audio.attachment) {
        if (this.isEditing) {
          payload.word.audios_attributes = [];

          payload.word.audios_attributes.push(omit(this.audio, ["url"]));

          if (this.word.audios.length) {
            this.word.audios.forEach((a) => {
              payload.word.audios_attributes.push({ id: a.id, _destroy: "1" });
            });
          }
        } else {
          payload.word.audios_attributes = [omit(this.audio, ["url"])];
        }
      }

      payload.word = omit(payload.word, unpermitted_params)
      payload.word.type = find(types, { value: this.word.type }).key 

      return payload
    }
  },
  watch: {
    async wordId(word_id) {
      if (this.isEditing && word_id) {
        let { data } = await this.$axios.get(`/words/${word_id}.json`)        
        // map word
        data.type = WordTypes[data.type].value
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
    .title{
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
  &-form{
    .form-group {
      display: flex;
      flex-wrap: wrap;
      box-sizing: border-box;
      width: 100%;
      margin-bottom: $gap * 3;
      .feedback{
        display: block;
        width: 100%;
        margin-top: 4px;
        margin-left: 33%;
        font-size: 10px;
      }
      label {
        max-width: 33.3%;
        flex: 1;
        padding: 0px ($gap * 2);
        align-self: center;
        text-align: right;
        &.is-sentence{
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
        .form-control, select, .input-file{
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
    .ls-modal-content{
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
          margin-left: 25px;
        }
      }
    }
  }
}
</style>