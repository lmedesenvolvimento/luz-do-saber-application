<template>
  <div id="ditado-frase">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word
          ref="embedded"
          :embedded="true"
          :text="initialWord"
          :word-id="word_id"
          :is-editing="isEditing"
          :word-type="word_type_1"
          :word-type-disabled="true"
          :audio-required="true"
          :image-required="false"
          :audio-visible="true"
          :image-visible="false"
        />
      </div>
      <div class="col-md-5"></div>
    </div>
    <div class="alternativa-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="alternativa-items-input-group"
            :options="words"
            :max-items="maxItems"
            :searchable="isSearchable"
            :label="'Palavras Faltando:'"
            :label-html="true"
            :initial-items="initialPalavras"
            @search="onSearch"
            @input="inputAlternativaItem"
          />
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
      word_type_1: WordTypes.frase.value,
      word_type: WordTypes.substantivo_comum.value,
      items: [],
      words_missing: [],
      initialWord: '',
      initialPalavras: []
    }
  },
  created() {
    if (this.isEditing) {
      this.initialWord = this.theKey.text
      this.theKey.value_items_attributes.map(el => {
        this.initialPalavras.push({ text: el.text })
        this.words_missing.push(el)
      })
    }
  },
  computed: {
    isSubmitDisabled() {
      return !this.$parent.hasDescription
    },
    types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    },
    data() {
      return this.$refs.embedded.word.text
    },
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    },
    isSearchable() {
      return this.words_missing.length < 2
    },
    word_id() {
      if (this.theKey) {
        return this.theKey.word_id
      }
      return null
    }
  },
  methods: {
    inputAlternativaItem(alternatives) {
      this.words_missing = alternatives.map(({ text }) => {
        return new Item('value', WordTypes.substantivo_comum.value, text)
      })
    },
    async submit() {
      try {
        this.busy = true
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        const items = []

        const word = data.text ? data.text : this.initialWord

        items.push(
          new Item('key', WordTypes.frase.value, word, null, this.words_missing)
        )
        Vue.set(this, 'items', items)

        //this.theKey.value_items_attributes = this.words_missing
        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 800)
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
#ditado-frase {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }
  .alternativa-items,
  .type {
    @include template-editor-field;
    margin: $gap 0px;
  }
}
</style>
