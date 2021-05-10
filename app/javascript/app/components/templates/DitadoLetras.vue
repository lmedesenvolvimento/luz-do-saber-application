<template>
<div id="ditado-letra">
  <div class="letras">
    <div class="row">
        <div class="col-md-7">
          <div class="letras-input-group">
            <label class="label is-top">Letras</label>
            <span class="input">
              <ls-select-letters :max-items="3" @change="onInput" :initial-letras="initialLetras"/>
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
    </div>
  </div>
</div>
</template>

<script>
import Vue from 'vue'
import { clone } from 'lodash'
import Item from '../../models/Item'
import TemplateMixin from '../../mixins/TemplateMixin'
export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      invalid: false,
      initialLetras: []
    }
  },
  created() {
     if(this.items.length > 0) {

     this.items.map((el, index) => {
       this.initialLetras.push(el.text)
      })
     
    } 
  },
  methods: {
    onInput({data, invalid}) {
      const alternatives = data
      const cloneItems = []

      this.invalid = invalid
      
      alternatives.map(({ text }) => {
        if (!text){
          return
        }
        const value_items_attributes = [
          new Item('value', this.WordTypes.letra.key, text)
        ]
        cloneItems.push(
          new Item('key', this.WordTypes.letra.key, text, null, value_items_attributes)
        )
      })

      Vue.set(this, 'items', cloneItems)
    },
    validateItems() {
      this.$emit('validateItems', !this.invalid && this.items.length)
    }
  }
}
</script>

<style lang="scss">
#ditado-letra {
  .letras {
    @include template-editor-field;
  }
}
</style>