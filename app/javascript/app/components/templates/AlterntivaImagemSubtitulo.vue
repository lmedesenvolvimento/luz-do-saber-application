<template>
  <div id="alternativa-imagem-subtitulo">
    <ls-template-description
      v-model="subtitle"
      @change="updateSubtitle"
      description-type="subtitle"
      description-text="subtítulo"
    />
    <!-- :template="templates" -->
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="correct-items-input-group"
            :options="words"
            :max-items="1"
            :searchable="subtitleItems.length < 1"
            label="Imagem do <br/>Subtítulo:"
            :label-html="true"
            :word-type="searchTypes"
            @search="onSearch"
            @search:focus="clear"
            @input="addSubtitle"
          />
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="images-items">
      <div class="row">
        <div class="col-md-12">
          <div class="correct-items-input-group">
            <div class="label">Imagem:</div>
            <ls-images-holder :items="subtitleImage"></ls-images-holder>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-7 first">
        <b>Selecione a imagem Correta:</b>
        <br />
        <ls-select-multiple
          ref="correct"
          class="correct-items-input-group"
          :options="words"
          :max-items="1"
          :searchable="correctItems.length < 1"
          :label="'Imagem Correta:'"
          :label-html="true"
          @search="onSearch"
          @search:focus="clear"
          @input="addItemCorrect"
        />
      </div>
      <div class="col-md-5"></div>
    </div>
    <div class="images-items">
      <div class="row">
        <div class="col-md-12">
          <div class="correct-items-input-group">
            <div class="label">Imagem:</div>
            <ls-images-holder :items="correctImage"></ls-images-holder>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-7">
        <b>Selecione as imagens Erradas:</b>
        <br />
        <ls-select-multiple
          ref="wrong1"
          class="incorrect-items-input-group"
          :label="'Imagens Erradas:'"
          :label-html="true"
          :options="words"
          :max-items="3"
          :searchable="wrongItems.length < 3"
          @search="onSearch"
          @search:focus="clear"
          @input="addItemWrong"
        />
      </div>
      <div class="col-md-5"></div>
    </div>
    <div class="images-items">
      <div class="row">
        <div class="col-md-12">
          <div class="correct-items-input-group">
            <div class="label">Imagens:</div>
            <ls-images-holder :items="wrongsImages"></ls-images-holder>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import TemplateMixin from '../../mixins/TemplateMixin'
import Item from '../../models/Item'
import { WordTypes } from '../../types'
import { mergeSelectedRemoteUrlWithNewItems } from '../../utils/array'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      busy: false,
      subtitle: '',
      word_type: WordTypes.input_custom.value,
      items: [],
      images: [],
      subtitleImage: [],
      correctImage: [],
      wrongsImages: [],
      subtitleItems: [],
      wrongItems: [],
      correctItems: [],
      words: []
    }
  },
  created() {
    this.changeImageOnUpdate()
  },
  computed: {
    searchFeedback() {
      return this.isSearchable
        ? 'Digite uma frase para continuar...'
        : 'Limite máximo de frases foi atigindo.'
    },
    searchTypes() {
      return this.typesArray([
        'substantivo_proprio',
        'substantivo_comum',
        'numero'
      ])
    },
    validate() {
      return this.correctItems.length > 1 && this.wrongItems.length > 1 && !!this.subtitle?.text
    }
  },
  methods: {
    addItemWrong(alternatives) {
      const items = alternatives.map(({ text, images, remote_image_url }) => {
        return new Item(
          'value',
          this.WordTypes.substantivo_comum.value,
          text,
          this.getImageUrl(images, remote_image_url)
        )
      })
      this.wrongsImages = mergeSelectedRemoteUrlWithNewItems(
        this.wrongsImages,
        items
      )
      this.images = mergeSelectedRemoteUrlWithNewItems(this.images, items)
      this.wrongItems = items
      this.clearWords()
      this.concatItems()
    },
    addItemCorrect(alternatives) {
      const values_item_attributes = [
        new Item(
          'key',
          this.WordTypes.substantivo_comum.value,
          alternatives.text
        )
      ]
      const items = alternatives.map(({ text, images, remote_image_url }) => {
        return new Item(
          'value',
          this.WordTypes.substantivo_comum.value,
          text,
          this.getImageUrl(images, remote_image_url)
        )
      })
      this.correctImage = mergeSelectedRemoteUrlWithNewItems(
        this.correctImage,
        items
      )
      this.images = mergeSelectedRemoteUrlWithNewItems(this.images, items)
      this.correctItems = items
      this.clearWords()
      if (this.theKey) this.theKey.value_items_attributes = items
      this.concatItems()
    },
    addSubtitle(alternatives) {
      const items = alternatives.map(({ text, images, remote_image_url }) => {
        return new Item(
          'key',
          this.WordTypes.substantivo_comum.value,
          text,
          this.getImageUrl(images, remote_image_url),
          this.correctItems
        )
      })
      this.subtitleImage = mergeSelectedRemoteUrlWithNewItems(
        this.subtitleImage,
        items
      )
      this.images = mergeSelectedRemoteUrlWithNewItems(this.images, items)
      this.subtitleItems = items
      this.concatItems()
      this.clearWords()
    },
    updateSubtitle(subtitle) {
      this.$emit('updateSubtitle', subtitle)
      this.validateItems()
    },
    clearWords() {
      this.words = []
    },
    concatItems() {
      this.items = [...this.wrongItems, ...this.subtitleItems]
      if (this.theKey) this.theKey.value_items_attributes = this.correctItems
    },
    validateItems() {
      this.$emit('validateItems', this.validate)
    }
  }
}
</script>

<style lang="scss">
#alternativa-imagem-subtitulo {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .ls-images-holder {
    display: flex;
    align-items: flex-end;
    justify-content: flex-start;
    max-width: 86%;
  }

  .palavra-items {
    padding: 16px 0px;
  }

  .images-items {
    margin-bottom: 16px;
  }

  .ls-images-holder,
  .v-select {
    flex: 6;
  }

  .first {
    padding: 8px;
  }

  .actions {
    padding-top: 30px;
  }

  .form-group {
    display: flex;
    align-items: center;
    padding: 2px 0px;
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
