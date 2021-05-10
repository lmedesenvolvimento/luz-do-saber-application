<template>
  <div id="caixa-de-palavras">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div
            class="items-input-group select-multiple incorrect-items-input-group"
          >
            <div class="label">
              Alternativas:
            </div>
            <v-select
              v-model="sentences"
              @input="addItem"
              :searchable="isSearchable"
              multiple
              taggable
              label="word_text"
            >
              <span slot="no-options">
                {{ searchFeedback }}
              </span>
            </v-select>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
      <div class="row">
        <div class="col-md-7">
          <div
            class="items-input-group select-multiple correct-items-input-group"
          >
            <div class="label">
              Alternativa Correta:
            </div>
            <v-select
              v-model="selectedItems"
              :options="modeledItems"
              @input="checkItem"
              label="word_text"
            ></v-select>
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
import Templates from '../../components/templates/templates.json'
import TemplateMixin from '../../mixins/TemplateMixin'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      types: [],
      sentences: [],
      clonedItem: [],
      selectedItems: [],
      initialAlternatives: [],
      initialCorrect: []
    }
  },
   created() {
    if(this.items.length > 0) {     
     this.items.map((el, index) => {
       if (el.type === "key") {
         this.selectedItems.push(el.text)
       } else {
         this.sentences.push(el.text)
       }
      })
    }
  },
  computed: {
    isSearchable() {
      return this.sentences.length < this.maxItems
    },
    searchFeedback() {
      return this.isSearchable
        ? 'Digite uma frase para continuar...'
        : 'Limite máximo de frases foi atigindo.'
    },
    modeledItems() {
      return this.items.filter((i) => i.type !== 'key')
    }
  },
  mounted() {
    this.types = [this.WordTypes.input_custom]
    this.items.push(new Item('key', this.WordTypes.input_custom.key, ''))
  },
  methods: {
    addItem(alternatives) {
      const incorrects = alternatives.map((text) => {
        return new Item('value', this.WordTypes.input_custom.key, text)
      })
      this.clonedItem = this.items = [
        ...this.items.filter(({ type }) => type === 'key'),
        ...incorrects
      ]
    },
    checkItem(item) {
      if (!item) return false
      const cloneItems = clone(
        this.clonedItem.filter((i) => i.word_text !== item.word_text)
      )
      this.items.filter(({ type }) => type !== 'key')
      cloneItems[0].value_items_attributes = []
      cloneItems[0].value_items_attributes.length = 0
      cloneItems[0].value_items_attributes.push(
        new Item('value', this.WordTypes.input_custom.key, item.word_text)
      )
      cloneItems[0].word_text = item.word_text
      // const cloneItems = clone(this.items.filter(({ type }) => type !== 'key'))
      // cloneItems.find((i) => i === item).type = 'key'

      Vue.set(this, 'items', cloneItems)
    },
    validateItems() {
      this.$emit(
        'validateItems',
        this.sentences.length > 3 && Boolean(this.selectedItems.word_text)
      )
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
