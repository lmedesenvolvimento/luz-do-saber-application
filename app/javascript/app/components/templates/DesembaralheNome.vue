<template>
  <div id="desembaralhe-nome">
    <div class="the-word">
      <div class="row">
        <div class="col-md-7">
          <div class="the-word-input-group">
            <label class="label">Palavra:*</label>
            <ls-select-word
              v-model="palavra"
              :type="theKey.word_type"
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
      palavra: []
    }
  },
  methods: {
    onInput({ text, images }) {
      let newItem = []
      if (this.theKey) {
        const value_items_attributes = [
          new Item('value', WordTypes.substantivo_proprio.value, text)
        ]

        newItem = [
          new Item(
            'key',
            WordTypes.substantivo_proprio.value,
            text,
            null,
            value_items_attributes
          )
        ]

        console.log(newItem)

        // ;[...text].map(el => {

        //   newItem.push(
        //     new Item(
        //       'key',
        //       WordTypes.substantivo_proprio.value,
        //       el,
        //       null,
        //       value_items_attributes
        //     )
        //   )
        // })
        

        // const value_items_attributes = [
        //   new Item('value', WordTypes.substantivo_proprio.value, text)
        // ]

        // newItem = new Item('key', WordTypes.substantivo_proprio.value, text, null, value_items_attributes)
        // this.theKey.remote_image_url = images[0].url
        // this.theKey.value_items_attributes[0].word_text = text
        // this.theKey.value_items_attributes[0].text = text
        // this.theKey.value_items_attributes[0].remote_image_url = images[0].url
      }

      Vue.set(this, 'items', newItem)
    },
    validateItems() {
      this.$emit('validateItems', true)
    }
  },
  created() {
    const value_items_attributes = [
      new Item('value', WordTypes.substantivo_proprio.value, '')
    ]
    value_items_attributes.word_source_type = 'external_param'
    // this.items.push(
    //   new Item('key', WordTypes.substantivo_comum.value, '', null, value_items_attributes)
    // )
    let newItem = new Item(
      'key',
      WordTypes.substantivo_proprio.value,
      '',
      null,
      value_items_attributes
    )
    newItem.word_source_type = 'external_param'

    // newItem.type = 'key'
    // newItem.word_type = WordTypes.substantivo_proprio.value
    // newItem.word_source_type = 'external_param'
    // newItem.value_items_attributes = value_items_attributes

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
#desembaralhe-nome {
  .the-word {
    @include template-editor-field;
  }

  .info-word {
    margin-top: 15px;
  }
}
</style>
