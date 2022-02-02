<template>
  <div id="alternativa-imagem-selecao">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="correct-items-input-group"
            labelHtml
            :options="words"
            :max-items="1"
            :searchable="itemCorrect.length === 0"
            label="Alternativa <br/> Correta:"
            :initial-items="initialCorreta"
            @search="onSearch"
            @search:focus="clear"
            @input="addItemCorrect"
          />
        </div>
        <div v-if="audioVisible" class="col-md-5 audio-line">
          <ls-audio-player :audio-url="getAudioUrl"></ls-audio-player>
        </div>
        <div v-else class="col-md-5">
          <ls-images-holder :items="images"></ls-images-holder>
        </div>
      </div>
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="correct-items-input-group"
            labelHtml
            :options="words"
            :max-items="maxItems"
            :searchable="itemsWrong.length < 3"
            :initial-items="initialIncorretas"
            label="Alternativas <br/> Erradas:"
            @search="onSearch"
            @search:focus="clear"
            @input="addItemWrong"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import Item from '../../models/Item'
import TemplateMixin from '../../mixins/TemplateMixin'
import Templates from './templates.json'
import { WordTypes } from '../../types'
import { mergeSelectedRemoteUrlWithNewItems } from '../../utils/array'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      images: [],
      itemCorrect: [],
      initialCorreta: [],
      initialIncorretas: [],
      itemsWrong: [],
      word_type: WordTypes.substantivo_comum,
      input: []
    }
  },
  computed: {
    audioVisible() {
      const template = Templates.find(t => t.templateName === this.template)
      return template ? template.mediaTypeShow === 'audio' : false
    },
    getAudioUrl() {
      return this.input[0] ? `${this.input[0].audios[0]?.url}` : null
    }
  },
  created() {
    if (this.isEditing) {
      this.initialCorreta = this.generateInputKeys
      this.initialIncorretas = this.generateInputValues
      this.addItemCorrect(this.generateInputKeys)
      this.addItemWrong(this.generateInputValues)
      this.input = ''
    }
    // mudando imagem do componente ao atualizar
    this.changeImageOnUpdate()
  },
  methods: {
    addItemCorrect(alternatives) {
      this.input = alternatives
      const items = alternatives.map(({ text, images, remote_image_url }) => {
        if (!text) {
          return
        }
        const value_items_attributes = [
          new Item('value', this.word_type.value, text)
        ]
        return new Item(
          'key',
          this.word_type.value,
          text,
          this.getImageUrl(images, remote_image_url),
          value_items_attributes
        )
      })
      // Populando novo array com imagens selecionadas
      this.images = mergeSelectedRemoteUrlWithNewItems(this.images, items)

      //this.itemCorrect = items.map(({ remote_image_url, ...i }) => i)
      this.itemCorrect = items

      const allItems = this.itemCorrect.concat(this.itemsWrong)
      Vue.set(this, 'items', allItems)
    },
    addItemWrong(alternatives) {
      const items = alternatives.map(({ text }) => {
        if (!text) {
          return
        }
        return new Item('value', this.word_type.key, text)
      })

      this.itemsWrong = items
      const allItems = this.itemsWrong.concat(this.itemCorrect)
      Vue.set(this, 'items', allItems)
    },
    validateSearchable() {
      this.searchable = this.items.length < 4
    },
    validateItems() {
      this.$emit('validateItems', this.items.length === 4)
    }
  }
}
</script>

<style lang="scss">
#alternativa-imagem-selecao {
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

  .audio-line {
    min-height: 32px;
    margin-bottom: $gap * 4;
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
