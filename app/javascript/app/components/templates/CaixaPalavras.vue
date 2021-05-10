<template>
  <div id="caixa-de-palavras">
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
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div class="correct-items-input-group">
            <div class="label">{{ caixas[0].title }}:</div>
            <input
              v-model="caixas[0].label"
              placeholder="Digite um rótulo para a caixa"
              class="form-control"
              maxlength="20"
              @input="renameBox(caixas[0])"
            />
          </div>
        </div>
        <div class="col-md-5">
          <ls-select-multiple
            class="correct-items-input-group"
            :options="words"
            :maxItems="maxItems"
            :word-type="type"
            :label="'Palavras:'"
            :initial-items="initialCaixa1"
            @filled="(toggle) => (caixas[0].filled = toggle)"
            @search="onSearch"
            @input="(word) => addItem(caixas[0], word)"
          />
          <div>(3 items)</div>
        </div>
        <br></br>
        <br></br>
        <div class="col-md-7">
          <div class="correct-items-input-group">
            <div class="label">{{ caixas[1].title }}:</div>
            <input
              v-model="caixas[1].label"
              placeholder="Digite um rótulo para a caixa"
              class="form-control"
              maxlength="20"
              @input="renameBox(caixas[1])"
            />
          </div>
        </div>
        <div class="col-md-5">
          <ls-select-multiple
            class="correct-items-input-group"
            :options="words"
            :maxItems="maxItems"
            :word-type="type"
            :label="'Palavras:'"
            :initial-items="initialCaixa2"
            @filled="(toggle) => (caixas[1].filled = toggle)"
            @search="onSearch"
            @input="(word) => addItem(caixas[1], word)"
          />
          <div>(3 items)</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { clone, values } from 'lodash'
import Item from '../../models/Item'
import Templates from '../../components/templates/templates.json'
import TemplateMixin from '../../mixins/TemplateMixin'
import { WordTypes } from '../../types'

const templateTypes = [
  WordTypes.substantivo_comum.value,
  WordTypes.silaba.value,
  WordTypes.letra.value
]


export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.substantivo_comum,
      modeledItems: [],
      initialCaixa1: [],
      initialCaixa2: [],
      caixas: [
        {
          title: 'Caixa 1',
          label: '',
          searchable: true,
          filled: false
        },
        {
          title: 'Caixa 2',
          label: '',
          searchable: true,
          filled: false
        }
      ]
    }
  },
   computed: {    
    types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    }
  },
  created() {
    this.modeledItems = this.caixas.map((c) => {
      const item = new Item(
        'key',
        this.WordTypes.input_custom.key,
        c.label,
        null,
        []
      )
      return { ...item, title: c.title }
    })

    if(this.items.length > 0) {

     this.caixas[0].label = this.items[0]?.text
     this.caixas[1].label = this.items[1]?.text
     this.items[0].value_items_attributes.map((el)=> {
        if (el.word_type === 0) {
          this.word_type = WordTypes.letra
        } else if (el.word_type === 1){
          this.word_type = WordTypes.silaba
        } else {
          this.word_type = WordTypes.substantivo_comum
        }
      this.initialCaixa1.push({text: el.text})
     })

     this.items[1].value_items_attributes.map((el)=> {
      this.initialCaixa2.push({text: el.text})
      
     })
     
    } 
  },
  watch: {
    word_type(){
      this.clearItems()
    }
  },
  methods: {
    addItem(box, alternatives) {
      const index = this.modeledItems.findIndex((i) => i.title === box.title)
      const values = alternatives.map(({ text }) => {
        return new Item('value', this.word_type.value, text)
      })
      this.modeledItems[index].value_items_attributes = values
      const modeled = this.modeledItems.map(({ title, ...i }) => i)
      box.words = values
      Vue.set(this, 'items', modeled)
    },
    renameBox(box) {
      const index = this.modeledItems.findIndex((i) => i.title === box.title)
      this.modeledItems[index].word_text = box.label
      const modeled = this.modeledItems.map(({ title, ...i }) => i)
      Vue.set(this, 'items', modeled)
    },
    clearItems() {
      // this.modeledItems= []
      // this.caixas= [
      //   {
      //     title: 'Caixa 1',
      //     label: '',
      //     searchable: true,
      //     filled: false,
      //     words: []
      //   },
      //   {
      //     title: 'Caixa 2',
      //     label: '',
      //     searchable: true,
      //     filled: false,
      //     words: []
      //   }
      // ],
      // this.items = []
    },
    validateItems() {
      if (this.caixas[0].words && this.caixas[1].words){
        this.$emit(
        'validateItems',
        this.items.every((i) => i.word_text !== '' && 
        this.caixas[0].words.length >= 3 && 
        this.caixas[1].words.length >= 3)
      )
      }   
      
    }
  }
}
</script>

<style lang="scss">
#caixa-de-palavras {
  .row {
    padding: 16px 0px;
    // margin: $gap 0px;
  }

  .push-input {
    margin-right: 50px;
  }
  .type, .alternatives {
    @include template-editor-field;
  }
  .alternatives {
    .label {
      align-self: flex-start;
    }
  }

  .correct-items,
  .incorrect-items {
    @include template-editor-field;
    margin: $gap 0px;
    &-input-group {
      .v-select {
        flex: 6;
      }
    }
  }
}
</style>
