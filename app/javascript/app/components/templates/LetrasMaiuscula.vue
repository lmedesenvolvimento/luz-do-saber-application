<template>
  <div id="letra-maiuscula">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word
          ref="embedded"
          :embedded="true"
          :word-type="word_type"
          :word-type-disabled="true"
          :audio-required="false"
          :audio-visible="false"
          :image-required="false"
          :word-id="word_id"
          :is-editing="isEditing"
          :text="initialPalavra"
        />
      </div>
      <div class="col-md-5"></div>
    </div>
    <div class="letras">
      <div class="row">
        <div class="col-md-7">
          <div class="letras-input-group">
            <label class="label is-top">Letras</label>
            <span class="input">
              <ls-select-letters
                :max-items="26"
                @change="onInput"
                :initial-letras="initialLetras"
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
        :disabled="busy || !hasDescription || letras.lenght < 0"
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
        :disabled="busy || !hasDescription || letras.lenght < 0"
      >
        Criar Atividade
      </button>
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
      letras: [],
      initialLetras: [],
      initialPalavra: [],
      remoteImgUrl: null
    }
  },
  created() {
    if (this.isEditing) {
      this.initialPalavra = this.theKey.text
      this.initialItems = this.theKey.value_items_attributes.map(el => {
        this.initialLetras.push(el.text)
      })
    }
  },
  computed: {
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    },
    word_id() {
      if (this.theKey) {
        return this.theKey.word_id
      }
      return null
    },
    getNameImage() {
      if (this.remoteImgUrl) {
        const url = this.remoteImgUrl
          .split('/')
          .pop()
          .split('?')
          .shift()
        if (url) return url
        else return ''
      } else return ''
    }
  },
  methods: {
    onInput({ data, invalid }) {
      const alternatives = data
      const cloneItems = []

      this.invalid = invalid

      alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        cloneItems.push(new Item('value', this.WordTypes.letra.value, text))
      })
      Vue.set(this, 'letras', cloneItems)
    },
    async submit() {
      try {
        this.busy = true
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        const items = []

        const word = data.text ? data.text : this.initialPalavra

        items.push(
          new Item('key', WordTypes.frase.value, word, null, this.letras)
        )

        Vue.set(this, 'items', items)
        // Salvando no banco novo template de questão

        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 1500)
      } catch (e) {
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
#letra-maiuscula {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }
  .letras {
    @include template-editor-field;
  }
}
</style>
