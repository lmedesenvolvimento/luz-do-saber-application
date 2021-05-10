<template>
  <div class="items-input-group select-multiple">
    <div v-if="labelHtml" v-html="label" class="label" >
      {{ label }}
    </div>
    <div v-else class="label">
      {{ label }}
    </div>
    <v-select
      ref="select"
      multiple
      label="text"
      :value="selectedItems"
      :options="dataOptions.filter((d) => !selectedItems.includes(d))"
      :searchable="searchable"
      :filterable="false"
      @search="onSearch"
      @search:focus="clear"
      @input="onInput"
    >
      <span slot="no-options">
        <p> 
          {{ searchFeedback }} 
          <button 
            v-if="isVisibleCreateWordButton" 
            @click="openNewWord"
            class="btn btn-xs btn-default pull-right"
          >
            Adicionar Palavra
          </button>
        </p>
      </span>
    </v-select>
    <modal :name="modalId" height="auto">
      <ls-modal-create-word
        :text="searchWord"
        :word-type="wordType"
        :word-type-disabled="true"
        @close="closeNewWord"
      />
    </modal>
  </div>
</template>

<script>
import shortid from 'shortid'
import { WordTypes } from '../../types'
import CreateWordModal from '../../modals/CreateWordModal'

const unpermittedWords = [
  WordTypes.silaba.value, 
  WordTypes.letra.value
]

export default {
  props: {
    items: Array,
    options: Array,
    maxItems: Number,
    wordType: {
      type: Number,
      default: WordTypes.substantivo_comum.value
    },
    label: String,
    labelHtml: {
      type: Boolean,
      default: false
    },
    searchable: {
      type: Boolean,
      default: undefined
    },
    initialItems: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      modalId: shortid.generate(),
      selectedItems: this.initialItems,
      dataOptions: this.options,
      searchWord: ''
    }
  },
  computed: {
    $searchable() {
      if (this.searchable !== undefined) {
        return this.searchable
      }
      return this.selectedItems.length < this.maxItems
    },
    searchFeedback() {
      if (this.$searchable) {
        if (this.searchWord.length > 0) {
          return 'Nenhum resultado encontrado.'
        }
        return ''
      }
      return 'Limite máximo de palavras foi atigindo.'
    },
    isVisibleCreateWordButton() {
      return this.$searchable && !unpermittedWords.includes(this.wordType)
    },
    isFilled() {
      return this.selectedItems.length >= this.maxItems
    }
  },
  created() {
    if (this.items && this.items.length) {
      this.selectedItems = this.items
    }
  },
  watch: {
    options(value) {
      this.dataOptions = value.filter(
        (x) => this.selectedItems.findIndex((s) => s.text === x.text) < 0
      )
    },
    initialItems(value) {
      this.selectedItems = value
    }

  },
  methods: {
    onSearch(search, loading) {
      if (search.length) {
        this.searchWord = search
      }
      this.$emit('search', search, loading, this.wordType)
    },
    onInput(words) {      
      this.$emit('filled', this.isFilled)
      this.$emit('input', this.isFilled ? words.slice(0, this.maxItems) : words)

      this.selectedItems = words
      
      this.$nextTick(() => {
        this.clear()
        this.forceFocus()
      })
    },
    openNewWord() {
      this.$modal.show(this.modalId)
    },
    closeNewWord(data){
      if (data && !this.isFilled) {
        this.selectedItems.push(data)
        // notify parent
        this.$emit('input', this.selectedItems)
        this.clear()
      }
      this.$modal.hide(this.modalId)
    },
    clear(search) {
      this.searchWord = ''
      this.$refs.select.search = ''
      this.dataOptions = []
    },
    clearSelection() {
      this.selectedItems = []
    },
    forceFocus() {
      if (!this.$searchable) {
        return
      }
      // force autofocus
      setTimeout(() => {
        const input = this.$refs.select.$el.querySelector('input')
        input.focus()
      }, 600)
    }
  }
}
</script>

<style lang="scss">
.select-multiple {
  .items-input-group {
    @include template-editor-field;
    margin: $gap 0px;
    &-input-group {
      .v-select {
        flex: 6;
      }
    }
  }
}
</style>
