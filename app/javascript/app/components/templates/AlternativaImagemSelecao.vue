<template>
  <div id="alternativa-imagem-selecao">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="correct-items-input-group"
            :options="words"
            :max-items="1"
            :searchable="itemCorrect.length === 0"
            label="Alternativa Correta:"
            :initial-items="initialCorreta"
            @search="onSearch"            
            @search:focus="clear"
            @input="addItemCorrect"
          />      
        </div>
        <div class="col-md-5">
          <ls-images-holder :items="images"></ls-images-holder>
        </div>
      </div>
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="correct-items-input-group"
            :options="words"
            :max-items="maxItems"
            :searchable="itemsWrong.length < 3"
            :initial-items="initialIncorretas"
            label="Alternativas Erradas:"
            @search="onSearch"
            @search:focus="clear"
            @input="addItemWrong"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { clone } from 'lodash'
import Item from '../../models/Item'
import Templates from '../../components/templates/templates.json'
import TemplateMixin from '../../mixins/TemplateMixin'
import { WordTypes } from '../../types'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      images: [],
      itemCorrect: [],
      initialCorreta: [],
      initialIncorretas: [],
      itemsWrong: [],
      word_type: WordTypes.substantivo_comum
    }
  },
  created() {
    if(this.items.length > 0) {
     this.items.map((el, index) => {
       if (el.type === "key") {
         this.initialCorreta.push({text: el.text})        
         this.itemCorrect.push(el)
         this.images.push(el)
       } else {
         this.initialIncorretas.push({text: el.text})
         this.itemsWrong.push(el)
       }
      })
    }
  },
  async mounted() {
    let type_eq = ''
    let text_cont = ''  

    if (this.items.length > 0 && this.isEditing) {
      this.items.map(async (el) => {
        type_eq = el.word_type
        text_cont = el.text
        const response = await this.$axios.get(`/words.json?q[type_eq]=${type_eq}&q[text_cont]=${text_cont}`)
        

        if (response.data.length === 1) this.addItemCorrect(response.data)
      });
    }
  },
  methods: {
    addItemCorrect(alternatives) {
      const items = alternatives.map(({ text, images }) => {
        if (!text){
          return
        }
        const value_items_attributes = [new Item('value', this.word_type.value, text)]
        return new Item( 'key', this.word_type.key, text, images[0], value_items_attributes)
      })      
      this.images = items     

      this.itemCorrect = items.map(({ remote_image_url, ...i }) => i)

      const allItems = this.itemCorrect.concat(this.itemsWrong)
      Vue.set(this, 'items', allItems)
    
    },
    addItemWrong(alternatives) {
      const items = alternatives.map(({ text }) => {
        if (!text){
          return
        }
        return new Item( 'value', this.word_type.key, text)
      })

      this.itemsWrong = items
      const allItems = this.itemsWrong.concat(this.itemCorrect)
      Vue.set(this, 'items', allItems)

    },
    validateSearchable() {
      this.searchable = this.items.length < 4
    },
    validateItems() {
      this.$emit('validateItems', this.items.length === 4)
    }
  }
}
</script>

<style lang="scss">
#alternativa-imagem-selecao {
  .ls-images-holder {
    display: flex;
    align-items: flex-end;
    justify-content: flex-start;
    max-width: 86%;
  }

  .ls-images-holder,
  .v-select {
    flex: 6;
  }

  .palavra-items {
    padding: 16px 0px;
  }
  .correct-items,
  .incorrect-items {
    @include template-editor-field;
    margin: $gap 0px;    
  }
}
</style>
