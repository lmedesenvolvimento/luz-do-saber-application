<template>
  <div id="charada-letras">
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
    <div class="row">
      <div class="col-md-7">
        <div class="form-group has-feedback">
          <label>Quantidade de Letras: </label>
          <input
            placeholder=""
            type="number"
            class="form-control"
            :value="initialValue"
            @input="setMaxItem"
          />
        </div>
      </div>
      <div class="col-md-5"></div>
    </div>
    <div class="alternativa-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="alternativa-items-input-group"
            :options="words"
            :max-items="max_items"
            :label="'Lista de Palavras:'"
            :label-html="true"
            :initial-items="initialPalavras"
            :searchable="isSearchable"
            v-model="palavras"
            @search="onSearch"
            @search:focus="clear"
            @input="inputAlternativaItem"
          />
        </div>
        <div class="col-md-5 word-geenrate">
          <span>{{ wordGenerate }}</span>
        </div>
      </div>
    </div>
    <div class="images-items">
      <div class="row">
        <div class="col-md-12">
          <div class="correct-items-input-group">
            <div class="label">
              Imagens:
            </div>
            <ls-images-holder :items="images"></ls-images-holder>
          </div>
        </div>
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
import { mergeSelectedRemoteUrlWithNewItems } from '../../utils/array'

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
      max_items: undefined,
      initialValue: undefined,
      initialPalavras: [],
      images: [],
      palavras: []
    }
  },
  created() {
    if (this.isEditing) {
      this.initialValue = this.items.length

      this.initialPalavras = this.generateInputKeys
      this.palavras = this.generateInputKeys
      this.inputAlternativaItem(this.generateInputKeys)
    }
    // mudando imagem do componente ao atualizar
    this.changeImageOnUpdate()
  },
  async mounted() {
    // let new_array = []
    // if (this.items.length > 0 && this.isEditing) {
    //   this.items.map(async (el) => {
    //     const response = await this.$axios.get(
    //       `/words.json?q[type_eq]=${el.word_type}&q[text_cont]=${el.text}`
    //     )
    //     new_array.push(response.data[0])
    //     this.inputAlternativaItem(new_array)
    //     this.initialPalavras = new_array
    //     this.palavras = new_array
    //   })
    // }
  },
  computed: {
    types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    },
    isSearchable() {
      return this.initialValue > this.items.length
    },
    wordGenerate() {
      let word = ''
      this.items.forEach(el => {
        word = `${word}${el.word_text.charAt(0)}`
      })
      return `${word}`
    }
  },
  methods: {
    setMaxItem(alternatives) {
      this.max_items = parseInt(alternatives.data)
      this.initialValue = parseInt(alternatives.data)
    },
    inputAlternativaItem(alternatives) {
      const items = alternatives.map(({ text, images }) => {
        return new Item(
          'key',
          this.WordTypes.substantivo_comum.value,
          text,
          images[0]?.url
        )
      })

      this.images = mergeSelectedRemoteUrlWithNewItems(this.images, items)

      // const modeledItem = items.map(({ remote_image_url, ...i }) => i)
      Vue.set(this, 'items', items)
    },
    validateItems() {
      this.$emit('validateItems', this.items.length >= this.maxItems)
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
#charada-letras {
  .alternativa-items,
  .type {
    @include template-editor-field;
    margin: $gap 0px;
  }

  .word-geenrate {
    margin-top: 7px;
    font-style: italic;
  }

  .ls-images-holder {
    display: flex;
    align-items: flex-end;
    justify-content: flex-start;
    max-width: 86%;
  }

  .ls-images-holder,
  .v-select {
    flex: 6;
  }

  .palavra-items {
    padding: 16px 0px;
  }

  .correct-items,
  .incorrect-items {
    @include template-editor-field;
    margin: $gap 0px;
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
}
</style>
