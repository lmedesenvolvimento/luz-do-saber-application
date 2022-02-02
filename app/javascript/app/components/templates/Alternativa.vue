<template>
  <div id="alternativa">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div
            class="items-input-group select-multiple incorrect-items-input-group"
          >
            <div class="label">Alternativas Corretas:</div>
            <v-select
              v-model="correct"
              @input="addItemCorrect"
              :searchable="isSearchable"
              multiple
              taggable
              label="word_text"
            >
              <span slot="no-options">{{ searchFeedback }}</span>
            </v-select>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div
            class="items-input-group select-multiple incorrect-items-input-group"
          >
            <div class="label">Alternativas Erradas:</div>
            <v-select
              v-model="incorrects"
              @input="addItemIncorrect"
              :searchable="isSearchable"
              multiple
              taggable
              label="word_text"
            >
              <span slot="no-options">{{ searchFeedback }}</span>
            </v-select>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import TemplateMixin from '../../mixins/TemplateMixin'
import Item from '../../models/Item'
import { WordTypes } from '../../types'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      busy: false,
      word_type: WordTypes.input_custom.value,
      items: [],
      incorrects: [],
      correct: [],
      alternativesCorrects: [],
      alternativesIncorrects: [],
      validate: true
    }
  },
  created() {
    if (this.isEditing) {
      this.addItemCorrect(
        this.generateInputKeys.map(({ text }) => {
          this.correct.push(text)
          return text
        })
      )
      this.addItemIncorrect(
        this.generateInputValues.map(({ text }) => {
          this.incorrects.push(text)
          return text
        })
      )
    }
  },
  computed: {
    searchFeedback() {
      return this.isSearchable
        ? 'Digite uma alternativa para continuar...'
        : 'Limite máximo de frases foi atigindo.'
    },
    isSearchable() {
      return this.incorrects.length + this.correct.length < 4
    },
    isSubmitDisabled() {
      return this.$parent.hasDescription && this.items.length > 3
    }
  },
  methods: {
    addItemIncorrect(alternatives) {
      const incorrects = alternatives.map(text => {
        return new Item('value', this.WordTypes.input_custom.key, text)
      })
      this.alternativesIncorrects = [...incorrects]
      this.items = [
        ...this.alternativesCorrects,
        ...this.alternativesIncorrects
      ]
    },
    addItemCorrect(alternatives) {
      const corrects = alternatives.map(text => {
        const value_items_attributes = new Item(
          'value',
          this.WordTypes.input_custom.key,
          text
        )
        return new Item('key', this.WordTypes.input_custom.key, text, null, [
          value_items_attributes
        ])
      })
      this.alternativesCorrects = [...corrects]
      this.items = [
        ...this.alternativesCorrects,
        ...this.alternativesIncorrects
      ]
    },
    async submit() {
      try {
        this.busy = true

        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 400)
      } catch (e) {
        this.$notify({
          group: 'danger',
          title: 'Falha',
          text: e.message
        })

        this.busy = false
      }
    }
  },
  mounted() {
    this.$emit('defaultActionsVisibilty', true)
  }
}
</script>

<style lang="scss">
#alternativa {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .palavra-items {
    margin: 20px 0 30px 0;
  }
  .form-group {
    display: flex;
    align-items: center;
    padding: ($gap * 2) 0px;
    margin-bottom: 0px;
    label {
      flex: 1;
    }
    .form-control {
      text-indent: 12px;
      padding: 0px;
      flex: 3;
    }
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
