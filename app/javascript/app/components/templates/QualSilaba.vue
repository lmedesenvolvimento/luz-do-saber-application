<template>
  <div id="qual-silaba">
    <div class="row">
      <div class="col-md-7">
        <div class="the-word">
          <div class="row">
            <div class="col-md-12">
              <div class="the-word-input-group">
                <div class="label">
                  Palavra:
                </div>
                <ls-select-word
                  v-model="theKey.word_text"
                  :type="theKey.word_type"
                  @input="onInputWord"
                />
              </div>
            </div>            
          </div>
        </div>
        <div class="correct-items">
          <div class="row">
            <div class="col-md-12">
              <ls-select-multiple
                class="correct-items-input-group"
                :options="words"
                :maxItems="maxItems"
                :label="'<small>Alternativas <br> Corretas</small>'"
                :initial-items="initialCorretas"
                :label-html="true"
                :word-type="WordTypes.silaba.value"
                @search="onSearch"
                @input="inputCorrectItem"
              />
              <div class="hint">Exemplo: [SA, PA, TO]</div>              
            </div>
          </div>
        </div>

        <div class="incorrect-items">
          <div class="row">
            <div class="col-md-12">
              <ls-select-multiple
                class="incorrect-items-input-group"
                :options="words"
                :max-items="maxItems"
                :searchable="this.items.length <= 11"
                :word-type="WordTypes.silaba.value"
                :initial-items="initialErradas"
                :label="'<small>Alternativas <br> Incorretas</small>'"
                :label-html="true"
                @search="onSearch"
                @input="inputIncorrectItem"
              />
              <div class="hint">Exemplo: [CHO, LA]</div>
            </div>
          </div>
        </div>
      </div>
      <!-- <div class="col-md-5">
        <label v-if="theKey.remote_image_url">Image:</label>
        <ls-images-holder :items="[theKey]" size="large"></ls-images-holder>
      </div> -->
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { clone } from 'lodash'

import Item from '../../models/Item'
import { WordTypes } from '../../types'

import TemplateMixin from '../../mixins/TemplateMixin'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.silaba.value,
      wordPreview: {},
      initialCorretas: [],
      initialErradas: [],
      initialPalavra: []
    }
  },
  created() {
    if (this.items.length > 1) {
      this.items.map((el)=> {
        if(el.type === "value") {
          this.initialErradas.push({text: el.text})
        } else {
          this.initialPalavra.push(el.text)
          el.value_items_attributes.map((x)=> {
            this.initialCorretas.push({text: x.text})
          })
        }
      })
    } else {
      this.items.push(
      new Item('key', WordTypes.substantivo_comum.value, '')
    )
    }
    
  },
  methods: {
    onInputWord(word) {
      const cloneItems = clone(this.items)
      cloneItems[0].remote_image_url = word.images.length ? word.images[0].url : ''
      Vue.set(this, 'items', cloneItems)
    },
    inputCorrectItem(alternatives){
      // Example for mapping correct inputs
      const cloneItems = clone(this.items)

      cloneItems[0].value_items_attributes = alternatives.map(({ text }) => {
        return new Item('value', WordTypes.silaba.value, text)
      })

      Vue.set(this, 'items', cloneItems)
    },
    inputIncorrectItem(alternatives){
      // Example for mapping incorrect inputs
      const incorrects = alternatives.map(({ text }) => {
        return new Item('value', WordTypes.silaba.value, text)
      })
      // union keys with incorrect items
      this.items = [
        ...this.items.filter(({ type }) => type === 'key'),
        ...incorrects
      ]
    },
    validateItems(){
      this.$emit(
        'validateItems', 
        this.theKey.word_text && this.items.length >= 2
      )
    }
  }
}
</script>

<style lang="scss">
#qual-silaba {
  .the-word, .correct-items, .incorrect-items {
    @include template-editor-field;
  }
}
</style>