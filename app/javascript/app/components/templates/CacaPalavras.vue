<template>
  <div id="caca-palavras">
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
            :max-items="maxItems"
            :word-type="word_type.value"
            :label="'Lista de Palavras:'"
            :searchable="items.length < 11"
            :initial-items="initialItems"
            :label-html="true"
            @search="onSearch"
            @input="inputAlternativaItem"
          />
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
      initialItems: [],
      word_type: WordTypes.substantivo_comum
    }
  },
  created() {
    if(this.items.length > 0 && this.isEditing) {    
     this.initialItems = this.items.map((el) => {
        if (el.word_type === 2) {
          this.word_type = WordTypes.substantivo_proprio
        } else {
          this.word_type = WordTypes.substantivo_comum
        }
        return {text: el.text}
      })
      const newItems = this.items.map(({id, value_items_attributes, word_id, ...old})=> {
       return old
      })
      Vue.set(this, 'items', newItems)
    } 
  },
  computed: {
     types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    }
  },
  methods: {
    inputAlternativaItem(alternatives){
      const items = alternatives.map(({ text }) => {
        return new Item('key', this.word_type.value, text)
      })

      Vue.set(this, 'items', items)
    },
    validateItems(){
      this.$emit('validateItems', this.items.length >= 4)
    },
    emptyList(){
    }
  },
  watch: {
    type(t){
      if (this.$refs.select && !this.initialItems.length > 0) {
        this.$refs.select.clearSelection()
      }
      this.items = []
      this.initialItems = []      
    }
  }
}
</script>

<style lang="scss">
#caca-palavras{
  .alternativa-items, .type {
    @include template-editor-field;
    margin: $gap 0px;    
  }
}
</style>
