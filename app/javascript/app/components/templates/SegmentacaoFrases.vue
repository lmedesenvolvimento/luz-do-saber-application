<template>
  <div id="caixa-de-palavras">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div
            class="items-input-group select-multiple incorrect-items-input-group"
          >
            <div class="label">Alternativa <br />Correta:</div>
            <v-select
              v-model="selectedItems"
              @input="checkItem"
              :searchable="isSearchableCorrect"
              multiple
              taggable
            >
              <span slot="no-options">
                {{ searchFeedbackCorrect }}
              </span></v-select
            >
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
              Alternativas <br />
              Erradas:
            </div>
            <v-select
              v-model="sentences"
              @input="addItem"
              :searchable="isSearchable"
              multiple
              taggable
            >
              <span slot="no-options">
                {{ searchFeedback }}
              </span>
            </v-select>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { clone, uniqBy } from 'lodash'
import Item from '../../models/Item'
import TemplateMixin from '../../mixins/TemplateMixin'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      sentences: [],
      selectedItems: [],
      correct: [],
      incorrect: []
    }
  },
  created() {
    if (this.isEditing) {
      this.sentences = this.generateInputValues.map(el => {
        return el.text
      })
      this.selectedItems.push(this.theKey.word_text)
      this.addItem(this.sentences)
      this.checkItem(this.selectedItems)
    }
  },
  computed: {
    isSearchable() {
      return this.sentences.length < 4
    },
    isSearchableCorrect() {
      return this.selectedItems.length < 1
    },
    searchFeedback() {
      return this.isSearchable
        ? 'Digite uma frase para continuar...'
        : 'Limite máximo de frases erradas foi atigindo.'
    },
    searchFeedbackCorrect() {
      return this.isSearchableCorrect
        ? 'Digite uma frase para continuar...'
        : 'Limite máximo de frases corretas foi atigindo.'
    }
  },

  methods: {
    addItem(alternatives) {
      this.incorrect = alternatives.map(text => {
        return new Item('value', this.WordTypes.input_custom.value, text)
      })
      this.items = [...this.correct, ...this.incorrect]
    },
    checkItem(alternatives) {
      this.correct = alternatives.map(text => {
        const values_item_attributes = [
          new Item('value', this.WordTypes.input_custom.value, text)
        ]
        return new Item(
          'key',
          this.WordTypes.input_custom.value,
          text,
          null,
          values_item_attributes
        )
      })
      this.items = [...this.correct, ...this.incorrect]
    },
    validateItems() {
      this.$emit('validateItems', this.items.length >= 4)
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
