<template>
  <div id="palavras-com-imagem">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="correct-items-input-group"
            :options="words"
            :max-items="maxItems"
            :searchable="items.length < maxItems"
            :initial-items="initialItems"
            label="Palavras:"
            @search="onSearch"
            @search:focus="clear"
            @input="addItem"
          />
          <div>({{ maxItems }} itens)</div>
        </div>
        <div class="col-md-5"></div>
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
import Item from '../../models/Item'
import TemplateMixin from '../../mixins/TemplateMixin'
import { mergeSelectedRemoteUrlWithNewItems } from '../../utils/array'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      images: [],
      initialItems: []
    }
  },
  created() {
    if (this.isEditing) {
      this.initialItems = this.generateInputKeys
      this.addItem(this.generateInputKeys)
    }
    // mudando imagem do componente ao atualizar
    this.changeImageOnUpdate()
  },
  methods: {
    addItem(alternatives) {
      // Example for mapping incorrect inputs
      const items = alternatives.map(({ text, images, remote_image_url }) => {
        return new Item(
          'key',
          this.WordTypes.substantivo_comum.value,
          text,
          this.getImageUrl(images, remote_image_url)
        )
      })
      // Populando novo array com imagens selecionadas
      this.images = mergeSelectedRemoteUrlWithNewItems(this.images, items)
      // const modeledItem = items.map(({ remote_image_url, ...i }) => i)
      Vue.set(this, 'items', items)
    },
    validateSearchable() {
      this.searchable = this.items.length < this.maxItems
    },
    validateItems() {
      this.$emit('validateItems', this.items.length === this.maxItems)
    }
  }
}
</script>

<style lang="scss">
#palavras-com-imagem {
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
