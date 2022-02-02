<template>
  <div id="acentuacao">
    <div class="alternativa-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="alternativa-items-input-group"
            :options="words"
            :max-items="3"
            :searchable="this.items.length < 3"
            :label="'Agudo:'"
            :initial-items="initialAgudo"
            :label-html="true"
            @search="onSearch"
            @input="alternatives => onInput('agudo', '´', alternatives)"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="alternativa-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="alternativa-items-input-group"
            :options="words"
            :max-items="3"
            :searchable="this.items.length < 3"
            :label="'Circunflexo:'"
            :initial-items="initialCircunflexo"
            :label-html="true"
            @search="onSearch"
            @input="alternatives => onInput('circunflexo', '^', alternatives)"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="alternativa-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="alternativa-items-input-group"
            :options="words"
            :max-items="3"
            :searchable="this.items.length < 3"
            :initial-items="initialTil"
            :label="'Til:'"
            :label-html="true"
            @search="onSearch"
            @input="alternatives => onInput('til', '~', alternatives)"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { values } from 'lodash'
import Item from '../../models/Item'
import TemplateMixin from '../../mixins/TemplateMixin'
import { WordTypes } from '../../types'

const templateTypes = [
  WordTypes.substantivo_comum.value,
  WordTypes.substantivo_proprio.value
]

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      agudo: [],
      circunflexo: [],
      til: [],
      initialAgudo: [],
      initialCircunflexo: [],
      initialTil: [],
      word_type: WordTypes.substantivo_comum
    }
  },
  created() {
    if (this.isEditing) {
      this.initialAgudo = this.generateItemsAcento('´')
      this.initialCircunflexo = this.generateItemsAcento('^')
      this.initialTil = this.generateItemsAcento('~')

      this.onInput('agudo', '´', this.generateItemsAcento('´'))
      this.onInput('til', '~', this.generateItemsAcento('~'))
      this.onInput('circunflexo', '^', this.generateItemsAcento('^'))
    }
  },
  computed: {
    types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    },
    allItems() {
      const items = []
      return items.concat(this.agudo, this.circunflexo, this.til)
    }
  },
  methods: {
    onInput(acento, caracter, alternatives) {
      const value_items_attributes = [
        new Item('value', this.WordTypes.caractere_especial.value, caracter)
      ]

      const items = alternatives.map(({ text }) => {
        return new Item(
          'key',
          this.WordTypes.substantivo_comum.value,
          text,
          null,
          value_items_attributes
        )
      })

      if (acento === 'agudo') {
        this.agudo = items
      } else if (acento === 'circunflexo') {
        this.circunflexo = items
      } else {
        this.til = items
      }

      Vue.set(this, 'items', this.allItems)
    },
    generateItemsAcento(acento) {
      const alternatives = this.rawItemsKeys.filter(k => {
        const values = this.rawItemsValuesByKey.filter(v => {
          return v.key_id === k.id && v.word_text === acento
        })
        if (values.length > 0) return values
      })
      return this.getKeysAcento(alternatives)
    },
    getKeysAcento(alternatives) {
      return alternatives.map(el => {
        return {
          text: el.word_text
        }
      })
    },
    validateItems() {
      this.$emit('validateItems', this.items.length >= 3)
    },
    emptyList() {}
  },
  watch: {
    type(t) {
      this.items = []
      if (this.$refs.select) {
        this.$refs.select.clearSelection()
      }
    }
  }
}
</script>

<style lang="scss">
#acentuacao {
  .alternativa-items,
  .type {
    @include template-editor-field;
  }
}
</style>
