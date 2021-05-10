<template>
  <div id="descubra-palavra">
    <div class="type">
    <div class="row">
      <div class="col-md-7">
        <div class="type-input-group">
          <label class="label">Tipo</label>
          <span class="input">
            <v-select 
              v-model="word_type"
              :filterable="false"
              :options="types"
              label="label"
              placeholder="Selecionar"
            />
          </span>
        </div>
      </div>
      <div class="col-md-5"></div>
    </div>
  </div>
    <div class="alternativa-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="alternativa-items-input-group"
            :options="words"
            :word-type="type"
            :max-items="1"
            :initial-items="initialPalavra"
            :label="'Palavra:'"
            :label-html="true"
            @search="onSearch"
            @input="inputAlternativaItem"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div class="items-input-group select-multiple incorrect-items-input-group">
            <div class="label">Parte para diminuir:</div>
            <v-select
              v-model="parte1"
              @input="addRetirar"
              :searchable="isSearchableRetirar"
              multiple
              taggable
              label="word_text"
            >
              <span slot="no-options">{{ searchFeedbackRetirar }}</span>
            </v-select>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div class="items-input-group select-multiple incorrect-items-input-group">
            <div class="label">Nova Palavra:</div>
            <v-select
              v-model="parte2"
              @input="addNova"
              :searchable="isSearchableNova"
              multiple
              taggable
              label="word_text"
            >
              <span slot="no-options">{{ searchFeedbackNova }}</span>
            </v-select>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { clone, values} from 'lodash'
import Item from '../../models/Item'
import TemplateMixin from '../../mixins/TemplateMixin'
import { WordTypes } from '../../types'

const templateTypes = [ 
  WordTypes.substantivo_comum.value,
  WordTypes.substantivo_proprio.value,
]

export default {
  mixins: [TemplateMixin],
  data(){
    return {
      items: [],
      word_type: WordTypes.substantivo_comum,
      parte1: [],
      parte2: [],
      initialPalavra: [],
      palavra_completa: "",
      parte_retirar: "",
      nova_palavra: ""
    }
  },
  created() {
    if(this.items.length > 0) {     
     this.items.map((el, index) => {
      this.initialPalavra.push({text: el.value_items_attributes[0].text})
      // this.parte1.push(el.value_items_attributes[2].text)
      // this.parte2.push(el.text)
      this.palavra_completa = el.value_items_attributes[0].text
      this.parte_retirar = el.value_items_attributes[2].text
      this.nova_palavra = el.text
      })
    }
  },
  computed: {
     types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    },
    searchFeedbackRetirar() {
      return this.isSearchableRetirar
        ? "Digite uma alternativa para continuar..."
        : "Limite máximo de frases foi atigindo.";
    },
    isSearchableRetirar() {
      return this.parte1.length <= 1;
    },
     searchFeedbackNova() {
      return this.isSearchableNova
        ? "Digite uma alternativa para continuar..."
        : "Limite máximo de frases foi atigindo.";
    },
    isSearchableNova() {
      return this.parte2.length <= 1;
    }
  },
  methods: {
    inputAlternativaItem(alternatives){      
      Vue.set(this, 'palavra_completa', alternatives[0].text.toUpperCase())
      this.adicionarItems()
    },
    addRetirar(alternatives) {           
      Vue.set(this, 'parte_retirar', alternatives[0].toUpperCase())
      this.adicionarItems()
    },

    addNova(alternatives) {
      Vue.set(this, 'nova_palavra', alternatives[0].toUpperCase())
      this.adicionarItems()
    },
    adicionarItems() {
      const value_items_attributes = [
        new Item('value', WordTypes.substantivo_comum.value, this.palavra_completa),        
        new Item('value', WordTypes.caractere_especial.value, "-"),
        new Item('value', WordTypes.input_custom.value, this.parte_retirar),
      ]   
      const clone = [new Item('key', WordTypes.input_custom.value, this.nova_palavra, null, value_items_attributes)]
      Vue.set(this, 'items', clone)
    },
    validateItems(){
      this.$emit('validateItems', this.palavra_completa)
    }
  },
  watch: {
    type(t){
      this.items = []
      if (this.$refs.select) {
        this.$refs.select.clearSelection()
      }
    }
  }
}
</script>

<style lang="scss">
#descubra-palavra{
  .alternativa-items, .type {
    @include template-editor-field;
    margin: $gap 0px;    
  }

  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .palavra-items {
    margin: 20px 0 30px 0;
  }

  .form-group {
    display: flex;
    align-items: center;
    padding: ($gap * 2) 0px;
    margin-bottom: 0px;
    label {
      flex: 1;
    }
    .form-control {
      text-indent: 12px;
      padding: 0px;
      flex: 3;
    }
  }

  .correct-items,
  .incorrect-items {
    @include template-editor-field;
    margin: $gap 0px;
    &-input-group {
      .v-select {
        flex: 3;
      }
    }
  }
}
</style>
