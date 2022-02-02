<template>
  <div id="som-silaba">
    <div class="row">
      <div class="col-md-12">
        <div class="correct-items">
          <div class="row">
            <div class="col-md-7">
              <ls-select-multiple
                class="correct-items-input-group"
                :options="words"
                :maxItems="1"
                :initial-items="initialCorrects"
                :searchable="correctItem.length < 1"
                :label="'<small>Alternativa <br> Correta:</small>'"
                :label-html="true"
                :word-type="WordTypes.silaba.value"
                @search="onSearch"
                @input="inputCorrectItem"
                v-model="input"
              />
              <div>(1 item)</div>
            </div>
            <div class="col-md-5">
              <ls-audio-player
                :audio-url="getAudioUrl"
                message="Essa sílaba"
              ></ls-audio-player>
            </div>
          </div>
        </div>

        <div class="incorrect-items">
          <div class="row">
            <div class="col-md-7">
              <ls-select-multiple
                class="incorrect-items-input-group"
                :options="words"
                :max-items="5"
                :searchable="incorrectItems.length < 5"
                :initial-items="initialIncorrects"
                :word-type="WordTypes.silaba.value"
                :label="'<small>Alternativas <br> Incorretas</small>'"
                :label-html="true"
                @search="onSearch"
                @input="inputIncorrectItem"
              />
              <div>(5 itens)</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import Item from '../../models/Item'
import { WordTypes } from '../../types'
import TemplateMixin from '../../mixins/TemplateMixin'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.silaba.value,
      input: [],
      wordPreview: {},
      correctItem: [],
      incorrectItems: [],
      initialCorrects: [],
      initialIncorrects: []
    }
  },
  created() {
    if (this.items.length > 0) {
      this.items.map((el, index) => {
        if (el.type === 'key') {
          this.initialCorrects.push({ text: el.text })
          this.correctItem.push(el)
        } else {
          this.initialIncorrects.push({ text: el.text })
          this.incorrectItems.push(el)
        }
      })
    }
  },
  async mounted() {
    if (this.items.length > 0 && this.isEditing) {
      this.items.map(async el => {
        if (el.type === 'key') {
          const response = await this.$axios.get(
            `/words.json?q[type_eq]=${el.word_type}&q[text_cont]=${el.text}`
          )
          this.input = response.data
        }
      })
    }
  },
  computed: {
    getAudioUrl() {
      return this.input[0] ? `${this.input[0].audios[0].url}` : null
    }
  },
  methods: {
    inputCorrectItem(alternatives) {
      // Example for mapping correct inputs
      const cloneItems = alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        const value_items_attributes = [new Item('value', this.word_type, text)]
        return new Item('key', this.word_type, text, '', value_items_attributes)
      })
      this.correctItem = cloneItems
      const allItems = this.correctItem.concat(this.incorrectItems)

      Vue.set(this, 'items', allItems)
    },
    inputIncorrectItem(alternatives) {
      const cloneItems = alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        return new Item('value', this.word_type, text)
      })
      this.incorrectItems = cloneItems
      const allItems = this.incorrectItems.concat(this.correctItem)

      Vue.set(this, 'items', allItems)
    },
    validateItems() {
      this.$emit(
        'validateItems',
        this.theKey.word_text && this.items.length >= 2
      )
    }
  }
}
</script>

<style lang="scss">
#som-silaba {
  .the-word,
  .correct-items,
  .incorrect-items {
    @include template-editor-field;
  }
}
</style>
