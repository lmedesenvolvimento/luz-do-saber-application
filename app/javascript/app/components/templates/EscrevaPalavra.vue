<template>
  <div id="escreva-palavra">
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
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="correct-items-input-group"
            ref="select"
            :options="words"
            :max-items="maxItems"
            :initial-items="initialItems"
            :word-type="word_type.value"
            v-model="input"
            label="Palavras:"
            @search="onSearch"
            @search:focus="clear"
            @input="addItem"
          />

          <div v-if="maxItems <= 1">({{ maxItems }} item)</div>
          <div v-else>({{ maxItems }} itens)</div>
        </div>
        <div class="col-md-5">
          <ls-audio-player :audio-url="getAudioUrl"></ls-audio-player>
        </div>
      </div>
    </div>
    <div class="images-items">
      <div class="row">
        <div class="col-md-12">
          <div class="correct-items-input-group">
            <div v-if="maxItems <= 1" class="label">Imagem:</div>
            <div v-else class="label">Imagens:</div>
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
import { mergeSelectedRemoteUrlWithNewItems } from '../../utils/array'

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
      images: [],
      initialItems: [],
      word_type: WordTypes.substantivo_comum,
      input: []
    }
  },
  computed: {
    types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    },
    typeSelect() {
      return this.word_type.value
    },
    getAudioUrl() {
      return this.input[0] ? `${this.input[0].audios[0].url}` : null
    }
  },
  created() {
    if (this.isEditing) {
      this.items.map(el => {
        if (el.word_type === 2) {
          this.word_type = WordTypes.substantivo_proprio
        } else {
          this.word_type = WordTypes.substantivo_comum
        }
      })
      this.initialItems = this.generateInputKeys
      this.input = this.generateInputKeys
      this.addItem(this.generateInputKeys)
      this.input = []
    }
    // mudando imagem do componente ao atualizar
    this.changeImageOnUpdate()
  },
  methods: {
    addItem(alternatives) {
      this.input = alternatives
      const items = alternatives.map(({ text, images, remote_image_url }) => {
        return new Item(
          'key',
          this.WordTypes.substantivo_comum.value,
          text,
          this.getImageUrl(images, remote_image_url)
        )
      })

      this.images = mergeSelectedRemoteUrlWithNewItems(this.images, items)
      Vue.set(this, 'items', items)
    },
    validateSearchable() {
      this.searchable = this.items.length < this.maxItems
    },
    validateItems() {
      this.$emit('validateItems', this.items.length === this.maxItems)
    }
  },
  watch: {
    type(t) {
      if (this.$refs.select && !this.initialItems.length > 0) {
        this.$refs.select.clearSelection()
      }
      this.items = []
      this.initialItems = []
      this.images = []
      this.input = []
    }
  }
}
</script>

<style lang="scss">
#escreva-palavra {
  .type,
  .alternatives {
    @include template-editor-field;
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
