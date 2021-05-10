<template>
  <div id="jogo-da-memoria">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="correct-items-input-group"
            :options="words"
            :max-items="maxItems"
            :initial-items="initialItems"
            label="Palavras:"
            @search="onSearch"
            @search:focus="clear"
            @input="addItem"
          />   
           <div>(4 itens)</div>   
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="images-items">
      <div class="row">
        <div class="col-md-12">
          <div class="correct-items-input-group">
            <div class="label">
              Imagens:
            </div>
            <ls-images-holder :items="images"></ls-images-holder>
          </div>
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
import { mergeSelectedRemoteUrlWithNewItems } from '../../utils/array'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      images: [],
      initialItems: []
    }
  },
  created() {
    //this.types = [this.WordTypes.letra, this.WordTypes.silaba]
    
     if(this.items.length > 0 && this.isEditing) {
     this.initialItems = this.items.map(({ text }) => {
        return {text: text}
      })
    } 

    this.$root.$on('word:select:image', ({ word, image }) => {
      const imagesIndex = this.images.findIndex((i) => i.word_text === word.text)      
      this.images[imagesIndex].remote_image_url = image
    })
  },
   async mounted() {
    let type_eq = ''
    let text_cont = '' 
    let new_array = [] 

    if (this.items.length > 0 && this.isEditing) {      
      this.items.map(async (el) => {
        type_eq = el.word_type
        text_cont = el.text
        const response = await this.$axios.get(`/words.json?q[type_eq]=${type_eq}&q[text_cont]=${text_cont}`)
        new_array.push(response.data[0])  
        this.addItem(new_array) 
        this.initialItems = new_array       
      });       
    }
  },
  methods: {
    addItem(alternatives) {
      // Example for mapping incorrect inputs
      const items = alternatives.map(({ text, images }) => {
        return new Item(
          'key',
          this.WordTypes.substantivo_comum.key,
          text,
          images[0]
        )
      })
      
      // Populando novo array com imagens selecionadas
      //this.images = mergeSelectedRemoteUrlWithNewItems(this.images, items)
      this.images = items;
      const modeledItem = items.map(({ remote_image_url, ...i }) => i);
      Vue.set(this, "items", modeledItem);
    },
    validateSearchable() {
      this.searchable = this.items.length < this.maxItems
    },
    validateItems() {
      this.$emit('validateItems', this.items.length === this.maxItems)
    }
  }
}
</script>

<style lang="scss">
#jogo-da-memoria {
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
