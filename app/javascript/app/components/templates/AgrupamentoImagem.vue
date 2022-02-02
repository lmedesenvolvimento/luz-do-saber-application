<template>
  <div>
    <div id="agrupamento-imagem">
      <div class="letras">
        <div class="row">
          <div class="col-md-7">
            <div class="letras-input-group">
              <label class="label is-top">Letras:</label>
              <span class="input">
                <ls-select-letters
                  :max-items="3"
                  @change="inputLetras"
                  :initial-letras="initialLetras"
                  ref="inputLetras"
                />
              </span>
            </div>
          </div>
          <div class="col-md-5"></div>
        </div>
      </div>
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
      <div v-if="letras[0]" class="alternativa-items">
        <div class="row">
          <div class="col-md-7">
            <ls-select-multiple
              ref="select"
              class="alternativa-items-input-group"
              :options="words"
              v-model="palavras0"
              :max-items="maxItems"
              :initial-items="initialPalavras0"
              :label="'Palavras com ' + letras[0].text + ':'"
              :label-html="true"
              @search="onSearch"
              @input="alternatives => inputPalavra(0, alternatives)"
            />
            <div>(1-4 itens)</div>
          </div>
        </div>
        <div class="images-items">
          <div class="row">
            <div class="col-md-12">
              <div class="correct-items-input-group">
                <div class="label">Imagens:</div>
                <ls-images-holder
                  v-if="showImages"
                  :items="images[0]"
                ></ls-images-holder>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-if="letras[1]" class="alternativa-items">
        <div class="row">
          <div class="col-md-7">
            <ls-select-multiple
              ref="select"
              class="alternativa-items-input-group"
              v-model="palavras1"
              :options="words"
              :max-items="maxItems"
              :initial-items="initialPalavras1"
              :label="'Palavras com ' + letras[1].text + ':'"
              :label-html="true"
              @search="onSearch"
              @input="alternatives => inputPalavra(1, alternatives)"
            />
            <div>(1-4 itens)</div>
          </div>
        </div>
        <div class="images-items">
          <div class="row">
            <div class="col-md-12">
              <div class="correct-items-input-group">
                <div class="label">Imagens:</div>
                <ls-images-holder
                  v-if="showImages"
                  :items="images[1]"
                ></ls-images-holder>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-if="letras[2]" class="alternativa-items">
        <div class="row">
          <div class="col-md-7">
            <ls-select-multiple
              ref="select"
              class="alternativa-items-input-group"
              v-model="palavras2"
              :options="words"
              :max-items="maxItems"
              :initial-items="initialPalavras2"
              :label="'Palavras com ' + letras[2].text + ':'"
              :label-html="true"
              @search="onSearch"
              @input="alternatives => inputPalavra(2, alternatives)"
            />
            <div>(1-4 itens)</div>
          </div>
        </div>
        <div class="images-items">
          <div class="row">
            <div class="col-md-12">
              <div class="correct-items-input-group">
                <div class="label">Imagens:</div>
                <ls-images-holder
                  v-if="showImages"
                  :items="images[2]"
                ></ls-images-holder>
              </div>
            </div>
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
      invalid: false,
      letras: [],
      initialLetras: [],
      initialPalavras0: [],
      initialPalavras1: [],
      initialPalavras2: [],
      images: [[], [], []],
      palavras0: [],
      palavras1: [],
      palavras2: [],
      showImages: true
    }
  },
  async mounted() {
    if (this.isEditing) {
      this.initialLetras = this.items.map(el => {
        return el.text
      })
      //mudando os dados da questão
      this.initialPalavras0 = this.generateActualValues(0)
      this.palavras0 = this.generateActualValues(0)
      this.initialPalavras1 = this.generateActualValues(1)
      this.palavras1 = this.generateActualValues(1)
      this.initialPalavras2 = this.generateActualValues(2)
      this.palavras2 = this.generateActualValues(2)
    }
    this.overwriteChangeImageOnUpdate()
  },
  computed: {
    types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    }
  },
  methods: {
    inputPalavra(index, alternatives) {
      this.items[index].value_items_attributes = alternatives.map(
        ({ text, images, remote_image_url }) => {
          return new Item(
            'value',
            this.WordTypes.substantivo_comum.value,
            text,
            this.getImageUrl(images, remote_image_url)
          )
        }
      )
      this.images[index] = this.items[index].value_items_attributes
    },
    inputLetras({ data, invalid }) {
      const alternatives = data
      const cloneItems = []

      this.letras = alternatives
      this.invalid = invalid

      alternatives.map((el, index) => {
        if (!el.text) {
          return
        }
        let value_items_attributes = []
        if (this.items[index]) {
          value_items_attributes = this.items[index].value_items_attributes
        }
        cloneItems.push(
          new Item(
            'key',
            this.WordTypes.letra.value,
            el.text,
            null,
            value_items_attributes
          )
        )
      })

      const notLetters = this.items.filter(
        i => i.word_type !== WordTypes.letra.value
      )
      const newItems = cloneItems.concat(notLetters)

      Vue.set(this, 'items', newItems)
    },
    validateItems() {
      this.$emit('validateItems', !this.invalid && this.items.length)
    },
    overwriteChangeImageOnUpdate() {
      this.$root.$on('word:select:image', ({ word, image }) => {
        for (let x = 0; x < this.images.length; x++) {
          const imagesIndex = this.images[x].findIndex(
            i => i.word_text === word.text
          )

          if (this.images[x][imagesIndex]) {
            this.images[x][imagesIndex].remote_image_url = image.url
            this.showImages = false
            setTimeout(() => {
              this.showImages = true
            }, 5)
            this.items[x].value_items_attributes[imagesIndex].remote_image_url =
              image.url
          }
        }
      })
    },
    generateActualValues(index) {
      const keyId = this.rawItemsKeys[index]?.id
      const values = this.rawItemsValuesByKey.filter(el => {
        return el.key_id === keyId
      })
      return values.map(i => {
        return {
          text: i.word_text,
          images: i.word_images,
          remote_image_url: i.remote_image_url
        }
      })
    }
  },
  watch: {
    type(t) {
      this.items = []
      if (this.$refs.select) {
        this.$refs.select.clearSelection()
      }
    },
    items(newItem, oldItems) {
      if (newItem.length < oldItems.length) {
        this.items = []
        this.palavras0 = []
        this.palavras1 = []
        this.palavras2 = []
        this.letras = []
      }
    },
    palavras0(palavras) {
      this.images[0] = palavras.map(({ text, images, remote_image_url }) => {
        return new Item(
          'value',
          this.WordTypes.substantivo_comum.value,
          text,
          this.getImageUrl(images, remote_image_url)
        )
      })
    },
    palavras1(palavras) {
      this.images[1] = palavras.map(({ text, images, remote_image_url }) => {
        return new Item(
          'value',
          this.WordTypes.substantivo_comum.value,
          text,
          this.getImageUrl(images, remote_image_url)
        )
      })
    },
    palavras2(palavras) {
      this.images[2] = palavras.map(({ text, images, remote_image_url }) => {
        return new Item(
          'value',
          this.WordTypes.substantivo_comum.value,
          text,
          this.getImageUrl(images, remote_image_url)
        )
      })
    }
  }
}
</script>

<style lang="scss">
#agrupamento-imagem {
  .letras {
    @include template-editor-field;
  }
  .alternativa-items,
  .type {
    @include template-editor-field;
    margin: $gap 0px;
  }
  .type {
    display: none;
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
}
</style>
