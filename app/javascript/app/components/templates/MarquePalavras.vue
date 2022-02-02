<template>
  <div id="marque-as-palavras" v-if="theKey">
    <ls-wordtype-radio-button
      v-model="theKey.word_type"
      :types="types"
      group="types"
    >
      <template slot="extra-input">
        <ls-select-word
          v-if="theKey.word_type === WordTypes.silaba.value"
          v-model="theKey.word_text"
          :type="theKey.word_type"
        />
        <input
          v-else
          v-model="theKey.word_text"
          class="form-control"
          placeholder="Informe a letra"
          maxlength="1"
        />
      </template>
    </ls-wordtype-radio-button>
    <div class="correct-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="correct-items-input-group"
            :items="correctItems"
            :options="words"
            :max-items="maxItems"
            :label="'<small>Alternativas <br> Corretas</small>'"
            :label-html="true"
            :searchable="searchable"
            @search="onSearch"
            @input="inputCorrectItem"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>

    <div class="incorrect-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="incorrect-items-input-group"
            :items="incorrectItems"
            :options="words"
            :max-items="maxItems"
            :label="'<small>Alternativas <br> Incorretas</small>'"
            :label-html="true"
            :searchable="searchable"
            @search="onSearch"
            @input="inputIncorrectItem"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import Item from '../../models/Item'
import TemplateMixin from '../../mixins/TemplateMixin'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      searchable: true
    }
  },
  computed: {
    correctItems() {
      return this.theKey.value_items_attributes
    },
    incorrectItems() {
      return this.items.filter(({ type }) => type === 'value')
    },
    types() {
      return [this.WordTypes.letra, this.WordTypes.silaba]
    },
    trueTotalItems() {
      try {
        const values_items = this.items.filter((i) => i.type === 'value').length
        return values_items + this.theKey.value_items_attributes.length
      } catch (error) {
        return false
      }
    }
  },
  methods: {
    inputCorrectItem(alternatives) {
      // Example for mapping correct inputs
      this.theKey.value_items_attributes = alternatives.map(({ text }) => {
        return new Item('value', this.WordTypes.substantivo_comum.value, text)
      })
    },
    inputIncorrectItem(alternatives) {
      // Example for mapping incorrect inputs
      const incorrects = alternatives.map(({ text }) => {
        return new Item('value', this.WordTypes.substantivo_comum.value, text)
      })

      // union keys with incorrect items
      this.items = [
        ...this.items.filter(({ type }) => type === 'key'),
        ...incorrects
      ]
    },
    validateItems() {
      this.searchable = this.trueTotalItems < this.maxItems
      this.$emit(
        'validateItems',
        this.theKey.word_text && this.trueTotalItems === this.maxItems
      )
    }
  },
  created() {
    if (this.isEditing) {
      return
    }
    this.items.push(new Item('key', this.WordTypes.letra.value, ''))
  }
}
</script>

<style lang="scss">
#marque-as-palavras {
  .correct-items,
  .incorrect-items {
    @include template-editor-field;
    margin: $gap 0px;
  }
}
</style>
