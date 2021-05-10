<template>
  <div id="ditado-frase">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word 
          ref="embedded"
          :embedded="true"
          :text="initialWord"
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
    
    <div class="actions">
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
        :disabled="busy || isSubmitDisabled"
      >
        Criar Atividade
      </button>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { clone } from 'lodash'
import TemplateMixin from '../../mixins/TemplateMixin'

import Item from '../../models/Item'
import Word from '../../models/Word'

import { WordTypes } from '../../types'

import CreateWordModal from '../../modals/CreateWordModal'


export default {
  mixins: [TemplateMixin],
  data(){
    return {
      busy: false,
      word_type_1: WordTypes.frase.value,
      word_type: WordTypes.substantivo_comum.value,
      items: [],
      words_missing: [],
      initialWord: [],
      initialPalavras: []
    }
  },
  created() {
    if(this.items.length > 0) {
      this.initialWord.push(this.items[0].text)
    }

    this.items[0]?.value_items_attributes.map((el)=> {
      this.initialPalavras.push({text: el.text})
      this.words_missing.push(el)
    })
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
    }
  },
  methods: { 
    inputAlternativaItem(alternatives){
      this.words_missing = alternatives.map(({ text }) => {
        return new Item('value', WordTypes.substantivo_comum.value, text)
      })

    },
    async submit(){
      try {
        this.busy = true        
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        const word = data

        this.items.push(
          new Item('key', WordTypes.frase.value, word.text)
        )

        this.theKey.value_items_attributes = this.words_missing
        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 400)
      } 
      catch(e) {
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
#ditado-frase{
  .actions{
    .btn:first-child {
      margin-right: 5px;
    }
  }
  .alternativa-items, .type {
    @include template-editor-field;
    margin: $gap 0px;    
  }
}
</style>