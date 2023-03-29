<template>
  <div class="ls-select-word">
    <v-select
      :value="input"
      :filterable="false"
      :options="options"
      @search="onSearch"
      placeholder="Selecionar"
      label="text"
      @input="onChangeValue"
    >
      <div slot="no-options">
        <p>
          Nenhum resultado encontrado.
          <button
            @click.stop="openNewWord"
            class="btn btn-xs btn-default pull-right"
          >
            Nova Palavra
          </button>
        </p>
      </div>
    </v-select>
    <modal :name="modalId" height="auto">
      <ls-modal-create-word
        :text="searchWord"
        :word-type="type"
        :word-type-visible="false"
        @close="closeNewWord"
      />
    </modal>
  </div>
</template>

<script>
import shortid from 'shortid'
import { debounce } from 'lodash'
import { WordTypes } from '../../types'

export default {
  model: {
    prop: 'input',
    event: 'change'
  },
  props: {
    input: null,
    type: {
      type: Number,
      default: WordTypes.substantivo_comum.value
    }
  },
  data() {
    return {
      modalId: shortid.generate(),
      options: [],
      searchWord: ''
    }
  },
  methods: {
    onSearch(search, loading) {
      if (search) {
        this.searchWord = search
      }
      // block ui
      loading(true)
      // fetch options in api
      this.search(loading, search, this)
    },
    search: debounce(async (loading, search, vm) => {
      const { data } = await vm.$axios.get(
        `/words.json?q[type_eq]=${vm.type}&q[text_cont]=${search}`
      )
      vm.options = data
      loading(false)
    }, 350),
    onChangeValue(value) {
      this.$emit('change', value ? value.text : '')
      this.$emit('input', value)
    },
    openNewWord() {
      this.$modal.show(this.modalId)
    },
    closeNewWord(data) {
      if (data) {
        this.onChangeValue(data)
      }
      this.$modal.hide(this.modalId)
    }
  }
}
</script>

<style lang="scss">
.ls-select-word {
  width: 75%;
}
</style>
