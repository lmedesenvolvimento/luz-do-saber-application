<template>
  <div id="rimas">
    <div class="correct-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="items-input-group select-multiple correct-items-input-group"
            :options="words"
            :maxItems="1"
            :initial-items="initialPalavra"
            :label="'Palavra:'"
            :word-type="WordTypes.substantivo_comum.value"
            :searchable="isSearchable"
            @search="onSearch"
            @input="addCorrectItem"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="palavra-item">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="items-input-group select-multiple correct-items-input-group"
            :options="words"
            :initial-items="initialCorrects"
            :maxItems="1"
            :label="'Alternativa Correta:'"
            :word-type="WordTypes.substantivo_comum.value"
            :searchable="isSearchable"
            @search="onSearch"
            @input="addPalavra"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="incorrect-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="items-input-group select-multiple correct-items-input-group"
            :options="words"
            :maxItems="2"
            :label="'Alternativas Erradas:'"
            :initial-items="initialErradas"
            :word-type="WordTypes.substantivo_comum.value"
            :searchable="isSearchableIncorreto"
            @search="onSearch"
            @input="addIncorrectItem"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
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
      sentences: [],
      clonedItem: [],
      palavra: [],
      validate: true,
      initialPalavra: [],
      initialCorrects: [],
      initialErradas: []
    }
  },
  created() {
    if (this.items.length > 0) {
      this.items.map((el, index) => {
        if (el.type === 'key') {
          this.initialPalavra.push({ text: el.text })
          this.initialCorrects.push({
            text: el.value_items_attributes[0].text
          })
        } else {
          this.initialErradas.push({ text: el.text })
        }
      })
    }
  },
  computed: {
    searchFeedback() {
      return this.isSearchable
        ? 'Digite uma frase para continuar...'
        : 'Limite máximo de frases foi atigindo.'
    },
    isSearchablePalavra() {
      return this.palavra.length < 1
    },
    isSearchableCorreto() {
      return this.items.length < this.maxItems
    },
    isSearchableIncorreto() {
      return this.items.length < 3
    },
    isSubmitDisabled() {
      return !this.$parent.hasDescription
    }
  },
  methods: {
    addIncorrectItem(alternatives) {
      const incorrects = alternatives.map(item => {
        return new Item('value', this.WordTypes.input_custom.key, item.text)
      })
      const clonedItem = [
        ...this.items.filter(({ type }) => type === 'key'),
        ...incorrects
      ]

      this.items = clonedItem
    },
    addPalavra(alternatives) {
      this.palavra = alternatives.map(item => {
        return new Item('value', this.WordTypes.input_custom.value, item.text)
      })

      this.theKey.value_items_attributes = this.palavra
    },
    addCorrectItem(alternatives) {
      const corrects = alternatives.map(item => {
        return new Item(
          'key',
          this.WordTypes.substantivo_comum.key,
          item.text,
          null,
          this.palavra
        )
      })
      const clonedItem = [
        ...this.items.filter(({ type }) => type === 'value'),
        ...corrects
      ]

      this.items = clonedItem
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
#rimas {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
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
