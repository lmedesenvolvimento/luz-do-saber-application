<template>
  <div id="quantidade-letras">
    <div class="type">
      <div class="row">
        <div class="col-md-7">
          <div class="type-input-group">
            <label class="label">Tipo</label>
            <span class="input">
              <v-select
                v-model="word_type"
                :filterable="false"
                :options="types"
                label="label"
                placeholder="Selecionar"
              />
            </span>
          </div>
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
            :word-type="type"
            :max-items="maxItems"
            :initial-items="initialWord"
            :label="'Palavra:'"
            :label-html="true"
            @search="onSearch"
            @input="inputAlternativaItem"
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
      word_type: WordTypes.substantivo_comum,
      initialWord: []
    }
  },
  created() {
    if (this.items.length > 0 && this.isEditing) {
      this.items.map((el) => {
        if (el.type === 'key') {
          if (el.word_type === 2) {
            this.word_type = WordTypes.substantivo_proprio
          } else {
            this.word_type = WordTypes.substantivo_comum
          }
          this.initialWord.push({ text: el.text })
        }
      })
    }
  },
  computed: {
    types() {
      return values(WordTypes).filter((t) => templateTypes.includes(t.value))
    }
  },
  methods: {
    inputAlternativaItem(alternatives) {
      let qntLetrasPositiva = 0
      let qntLetrasNegativa = 0
      const items = alternatives.map(({ text, info }) => {
        // const numero = info.total_letters.toString()
        // const value_items_attributes = [
        //   new Item('value', WordTypes.numero.value, numero)
        // ]
        qntLetrasPositiva = (info.total_letters + 1).toString()
        qntLetrasNegativa = (info.total_letters - 1).toString()
        // return new Item('key', this.WordTypes.substantivo_comum.value, text, null, value_items_attributes)
        return new Item('key', this.word_type.value, text)
      })

      const random = [
        items[0],
        new Item('value', WordTypes.numero.key, qntLetrasPositiva),
        new Item('value', WordTypes.numero.key, qntLetrasNegativa),
        new Item('value', WordTypes.numero.key, '1.5', null, null, 'random')
      ]

      Vue.set(this, 'items', random)
    },
    validateItems() {
      this.$emit('validateItems', this.items.length >= this.maxItems)
    }
  },
  watch: {
    type(t) {
      if (this.$refs.select && !this.initialWord.length > 0) {
        this.$refs.select.clearSelection()
      }
      this.items = []
      this.initialWord = []
    }
  }
}
</script>

<style lang="scss">
#quantidade-letras {
  .alternativa-items,
  .type {
    @include template-editor-field;
    margin: $gap 0px;
  }
}
</style>
