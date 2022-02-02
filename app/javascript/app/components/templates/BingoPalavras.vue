<template>
  <div id="bingo-de-palavras">
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
                @input="onChangeType"
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
      <div v-if="type === WordTypes.letra.value" class="row">
        <div class="col-md-7">
          <div class="alternatives-input-group">
            <label class="label">Cartela Aluno</label>
            <span class="input">
              <ls-select-letters
                :max-items="4"
                @change="onInputStudent"
                :initial-letras="initialLetrasCorretas"
              />
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
        <div class="col-md-7">
          <div class="alternatives-input-group">
            <label class="label">Demais Letras</label>
            <span class="input">
              <ls-select-letters
                :max-items="8"
                @change="onInput"
                :initial-letras="initialLetrasErradas"
              />
            </span>
          </div>
          <div class="aviso">
            *Não repetir letras da cartela do aluno
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
      <div v-else-if="type === WordTypes.silaba.value" class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="student"
            class="alternatives-input-group"
            :options="words"
            :maxItems="contextMaxItemsStudents"
            :initial-items="initialPalavrasCorretas"
            :label-html="true"
            :label="'<div>Cartela Aluno:</div><div>(4 items)</div>'"
            :word-type="WordTypes.silaba.value"
            @search="onSearch"
            @input="onInputStudent"
          />
        </div>
        <div class="col-md-5"></div>

        <div class="col-md-7">
          <ls-select-multiple
            ref="alternatives"
            class="alternatives-input-group"
            :options="words"
            :maxItems="contextMaxItems"
            :initial-items="initialPalavrasErradas"
            :label-html="true"
            :label="'<div>Palavras:</div><div>(8 items)</div>'"
            :word-type="WordTypes.silaba.value"
            @search="onSearch"
            @input="onInput"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
      <div v-else class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="student"
            class="alternatives-input-group"
            :options="words"
            :initial-items="initialPalavrasCorretas"
            :maxItems="contextMaxItemsStudents"
            :label-html="true"
            :label="'<div>Cartela Aluno:</div><div>(4 items)</div>'"
            :word-type="word_type.value"
            @search="onSearch"
            @input="onInputStudent"
          />
        </div>
        <div class="col-md-5"></div>

        <div class="col-md-7">
          <ls-select-multiple
            ref="alternatives"
            class="alternatives-input-group"
            :options="words"
            :maxItems="contextMaxItems"
            :initial-items="initialPalavrasErradas"
            :label-html="true"
            :label="'<div>Palavras:</div><div>(8 items)</div>'"
            :word-type="word_type.value"
            @search="onSearch"
            @input="onInput"
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
import { WordTypes } from '../../types'
import TemplateMixin from '../../mixins/TemplateMixin'
import Item from '../../models/Item'

const templateTypes = [
  WordTypes.letra.value,
  WordTypes.substantivo_comum.value,
  WordTypes.substantivo_proprio.value,
  WordTypes.silaba.value
]

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.letra,
      items: [],
      isStudentInvalid: false,
      isAlternativesInvalid: false,
      initialLetrasCorretas: [],
      initialLetrasErradas: [],
      initialPalavrasCorretas: [],
      initialPalavrasErradas: []
    }
  },
  created() {
    if (this.items.length > 0) {
      this.items.map((el, index) => {
        this.changeWordType(el.word_type)
        if (this.word_type.value === 0) {
          if (el.type === 'key') {
            this.initialLetrasCorretas.push(el.text)
          } else if (el.type === 'value') {
            this.initialLetrasErradas.push(el.text)
          }
        } else {
          if (el.type === 'key') {
            this.initialPalavrasCorretas.push({ text: el.text })
          } else if (el.type === 'value') {
            this.initialPalavrasErradas.push({ text: el.text })
          }
        }
      })
    }
  },
  computed: {
    types() {
      return values(WordTypes).filter((t) => templateTypes.includes(t.value))
    },
    invalid() {
      return this.isAlternativesInvalid || this.isStudentInvalid
    },
    contextMaxItems() {
      if (this.type === WordTypes.substantivo_proprio.value) {
        return 8
      }
      return 8
    },
    contextMaxItemsStudents() {
      if (this.type === WordTypes.substantivo_proprio.value) {
        return 4
      }
      return 4
    }
  },
  methods: {
    changeWordType(t) {
      if (t === 0) {
        this.word_type = WordTypes.letra
      } else if (t === 1) {
        this.word_type = WordTypes.silaba
      } else if (t === 2) {
        this.word_type = WordTypes.substantivo_proprio
      } else if (t === 3) {
        this.word_type = WordTypes.substantivo_comum
      }
    },
    onChangeType() {
      this.$refs.student.clearSelection()
      this.$refs.alternatives.clearSelection()
    },
    onInput(items) {
      const alternatives = items.data ? items.data : items
      const cloneItems = []

      this.isAlternativesInvalid = items.invalid ? true : false

      alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        cloneItems.push(new Item('value', this.word_type.value, text, null))
      })

      this.items = [
        ...this.items.filter(({ type }) => type === 'key'),
        ...cloneItems
      ]
    },

    onInputStudent(items) {
      const alternatives = items.data ? items.data : items
      const cloneItems = []

      this.isStudentInvalid = items.invalid ? true : false

      alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        // const value_items_attributes = [
        //   new Item('value', this.type.value, text)
        // ]
        cloneItems.push(new Item('key', this.word_type.value, text, null))
      })

      this.items = [
        ...this.items.filter(({ type }) => type === 'value'),
        ...cloneItems
      ]
    },

    validateItems() {
      this.$emit('validateItems', !this.invalid && this.items.length >= 12)
    }
  },
  watch: {
    type(t) {
      if (!this.isEditing) this.items = []
      if (this.$refs.student && !this.isEditing) {
        this.$refs.student.clearSelection()
      }
      if (this.$refs.alternatives && !this.isEditing) {
        this.$refs.alternatives.clearSelection()
      }
    }
  }
}
</script>

<style lang="scss">
#bingo-de-palavras {
  .type,
  .alternatives {
    @include template-editor-field;
  }
  .aviso {
    text-align: end;
  }
  .alternatives {
    &-input-group {
      padding: ($gap * 2) 0px;
    }
    .label {
      align-self: flex-start;
    }
  }
}
</style>
