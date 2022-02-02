<template>
  <div id="sinais-de-pontuacao">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word
          ref="embedded"
          :embedded="true"
          :text="initialText"
          :word-type="word_type"
          :word-type-disabled="true"
          :word-type-visible="false"
          :audio-required="false"
          :image-required="false"
          :audio-visible="false"
          :image-visible="false"
        />
      </div>
      <div class="col-md-5"></div>
    </div>
    <div class="letras">
      <div class="row">
        <div class="col-md-7">
          <div class="letras-input-group">
            <label class="label is-top">Sinal Correto:</label>
            <span class="input">
              <ls-select-special-character
                :max-items="1"
                @change="onInput"
                :initial-letras="initialSinalCorreto"
              />
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
      <div class="letras">
        <div class="row">
          <div class="col-md-7">
            <div class="letras-input-group">
              <label class="label is-top">Sinais Errados:</label>
              <span class="input">
                <ls-select-special-character
                  :max-items="10"
                  @change="onInputErrado"
                  :initial-letras="initialSinalErrado"
                />
              </span>
            </div>
          </div>
          <div class="col-md-5"></div>
        </div>
      </div>
      <div v-if="isEditing" class="actions">
        <a tag="button" class="btn btn-default" :href="backUrl" :disabled="busy"
          >Cancelar
        </a>
        <button
          @click="submit"
          class="btn btn-primary"
          :disabled="busy || !hasDescription"
        >
          Editar Atividade
        </button>
      </div>
      <div v-else class="actions">
        <router-link
          tag="button"
          class="btn btn-default"
          :to="{ name: 'templates' }"
          :disabled="busy"
          >Cancelar</router-link
        >
        <button
          @click="submit"
          class="btn btn-primary"
          :disabled="busy || !hasDescription"
        >
          Criar Atividade
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import TemplateMixin from '../../mixins/TemplateMixin'
import Item from '../../models/Item'
import { WordTypes } from '../../types'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      busy: false,
      word_type: WordTypes.frase.value,
      items: [],
      sinalCorreto: [],
      sinaisErrados: [],
      invalid: false,
      initialSinalCorreto: [],
      initialSinalErrado: [],
      initialText: ''
    }
  },
  created() {
    if (this.isEditing) {
      this.initialSinalCorreto.push(this.theKey.value_items_attributes[0].text)
      this.initialSinalErrado = this.generateInputValues.map(el => {
        return el.text
      })
      this.sinalCorreto = this.generateInputKeys
      this.sinaisErrados = this.generateInputValues
      this.initialText = this.theKey.text
    }
  },
  computed: {
    isSubmitDisabled() {
      return this.sinaisErrados.length < 3 || this.sinalCorreto < 1
    },
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    }
  },
  methods: {
    onInput({ data, invalid }) {
      const alternatives = data
      const itemCorreto = []
      alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        itemCorreto.push(
          new Item('value', this.WordTypes.caractere_especial.value, text)
        )
      })
      Vue.set(this, 'sinalCorreto', itemCorreto)
    },
    onInputErrado({ data, invalid }) {
      const alternatives = data
      const itemsErrados = []
      alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        itemsErrados.push(
          new Item('value', this.WordTypes.caractere_especial.value, text)
        )
      })
      Vue.set(this, 'sinaisErrados', itemsErrados)
    },
    async submit() {
      try {
        this.busy = true
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        const word = data

        const itemsCorrect = []

        itemsCorrect.push(
          new Item(
            'key',
            WordTypes.frase.value,
            word.text,
            null,
            this.sinalCorreto
          )
        )

        const newItems = itemsCorrect.concat(this.sinaisErrados)
        Vue.set(this, 'items', newItems)

        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 1000)
      } catch (e) {
        this.busy = true
        this.$notify({
          group: 'danger',
          title: 'Falha',
          text: e.message
        })

        this.busy = false
      }
    }
  },
  mounted() {
    this.$emit('defaultActionsVisibilty', false)
  }
}
</script>

<style lang="scss">
#sinais-de-pontuacao {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }
  .type,
  .alternatives {
    @include template-editor-field;
  }
  .alternatives {
    .label {
      align-self: flex-start;
    }
  }
  .letras {
    @include template-editor-field;
  }
}
</style>
