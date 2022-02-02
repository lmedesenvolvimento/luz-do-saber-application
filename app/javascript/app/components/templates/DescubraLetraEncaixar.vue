<template>
  <div id="palavra-secreta">
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
    <div class="alternatives">
      <div class="row">
        <div class="col-md-7">
          <div class="alternatives-input-group">
            <label class="label">Palavra</label>
            <ls-select-word
              v-model="wordValue"
              :type="type"
              @change="changeWord"
            />
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div v-if="wordValue" class="letras">
      <div class="row">
        <div class="col-md-7">
          <div class="letras-input-group">
            <label class="label is-top">Letra Faltando</label>
            <span class="input">
              <ls-select-letters
                :max-items="1"
                @change="onInput"
                :initial-letras="initialLetra"
              />
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div v-if="ifLetra" class="letras">
      <div class="row">
        <div class="col-md-7">
          <div class="letras-input-group">
            <label class="label is-top">Letras Erradas</label>
            <span class="input">
              <ls-select-letters
                :remover-letra="letraRemover"
                :max-items="4"
                @change="onInputErrado"
                :initial-letras="initialLetras"
              />
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { values } from 'lodash'
import { WordTypes } from '../../types'
import TemplateMixin from '../../mixins/TemplateMixin'

import Item from '../../models/Item'

const templateTypes = [
  WordTypes.substantivo_comum.value,
  WordTypes.substantivo_proprio.value
]

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.substantivo_comum,
      items: [],
      cloneItems: [],
      invalid: false,
      ifLetra: false,
      letraRemover: null,
      initialLetra: [],
      initialLetras: [],
      wordSelected: null,
      wordValue: ''
    }
  },
  computed: {
    types() {
      return values(WordTypes).filter((t) => templateTypes.includes(t.value))
    }
  },
  methods: {
    changeWord(item) {
      this.wordSelected.text = item
      this.wordSelected.word_text = item
    },
    onInput({ data }) {
      const alternatives = data
      alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        this.letraRemover = text
        const value_items_attributes = [
          new Item('value', this.WordTypes.letra.value, text)
        ]
        this.wordSelected.value_items_attributes = value_items_attributes
        this.ifLetra = true
      })
      this.items = this.cloneItems.concat(this.wordSelected)
    },
    onInputErrado({ data, invalid }) {
      const alternatives = data
      const itemsErrados = []
      alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        itemsErrados.push(new Item('value', this.WordTypes.letra.value, text))
      })
      Vue.set(this, 'cloneItems', itemsErrados)

      this.items = this.cloneItems.concat(this.wordSelected)
    },
    createItems() {
      this.wordSelected = new Item('key', this.type, '')
    },
    validateItems() {
      this.$emit('validateItems', this.wordValue && this.items.length >= 5)
    }
  },
  watch: {
    word_type() {
      this.createItems()
    }
  },
  created() {
    if (this.isEditing) {
      this.ifLetra = true
      this.items.map((el) => {
        if (el.type === 'key') {
          this.createItems()
          this.wordSelected = el
          this.wordValue = el.text
          this.initialLetra.push(el.value_items_attributes[0].text)
        } else {
          this.initialLetras.push(el.text)
        }
      })
    } else {
      this.createItems()
    }
  }
}
</script>

<style lang="scss">
#palavra-secreta {
  .type,
  .alternatives {
    @include template-editor-field;
  }
  .alternatives {
    .label {
      align-self: flex-start;
    }
  }
  .letras {
    @include template-editor-field;
  }
}
</style>
