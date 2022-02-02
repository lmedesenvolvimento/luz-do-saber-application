<template>
  <div id="consoante-nome">
    <div class="the-word">
      <div class="row">
        <div class="col-md-7">
          <div class="the-word-input-group">
            <label class="label">Palavra:*</label>
            <ls-select-word
              v-model="palavra"
              :type="word_type"
              @input="onInput"
            />
            <div class="info-word">
              <i>*Não prencha para usar nome informado no portal</i>
            </div>
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
        return false
      } else return true
    },
    validateItems() {
      this.$emit('validateItems', !!this.items.length > 0)
    }
  },
  created() {
    const value_items_attributes = [
      new Item('value', WordTypes.substantivo_proprio.value, '')
    ]

    let newItem = new Item(
      'key',
      WordTypes.substantivo_proprio.value,
      '',
      null,
      value_items_attributes
    )
    newItem.word_source_type = 'external_param'

    if (!this.isEditing) {
      this.items.push(newItem)
    }
    this.$emit('validateItems', true)

    if (this.isEditing) {
      this.items.map((el) => {
        if (el.text) {
          this.palavra = this.palavra + el.text
        }
      })
    }
  }
}
</script>

<style lang="scss">
#consoante-nome {
  .the-word {
    @include template-editor-field;
  }
  .info-word {
    margin-top: 15px;
  }
}
</style>
