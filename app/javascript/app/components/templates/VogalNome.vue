<template>
  <div id="vogal-nome">
    <div class="the-word">
      <div class="row">
        <div class="col-md-7">
          <div class="the-word-input-group">
            <label class="label">Palavra:</label>
            <ls-select-word
              v-model="palavra"
              :type="word_type"
              @input="onInput"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import TemplateMixin from '../../mixins/TemplateMixin'
import { WordTypes } from '../../types'
import Item from '../../models/Item'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.substantivo_proprio.value,
      palavra: [],
      items: []
    }
  },
  created() {
    if (this.isEditing && this.items.length > 0) {
      let palavraTemp = ''
      this.items.map((el) => {
        palavraTemp = palavraTemp + el.text
      })
      this.palavra = palavraTemp
    }
  },
  methods: {
    onInput({ text }) {
      this.items = []
      for (let i = 0; i < text.length; i++) {
        if (this.checkConsoante(text[i])) {
          const value_items_attributes = [
            new Item('value', WordTypes.letra.value, text[i])
          ]
          this.items.push(
            new Item(
              'key',
              WordTypes.letra.value,
              text[i],
              null,
              value_items_attributes
            )
          )
        } else {
          this.items.push(new Item('value', WordTypes.letra.value, text[i]))
        }
      }
    },
    checkConsoante(l) {
      const letra = l.toLowerCase()
      if (
        letra == 'a' ||
        letra == 'e' ||
        letra == 'i' ||
        letra == 'o' ||
        letra == 'u'
      ) {
        return true
      } else return false
    },
    validateItems() {
      this.$emit('validateItems', !!this.items.length > 0)
    }
  }
}
</script>

<style lang="scss">
#vogal-nome {
  .the-word {
    @include template-editor-field;
  }
}
</style>
