<template>
  <div id="alternativa-texto-subtitulo">
    <ls-template-description
      v-model="subtitle"
      @change="updateSubtitle"
      description-type="subtitle"
      description-text="subtítulo"
      optional
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
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div
            class="items-input-group select-multiple incorrect-items-input-group"
          >
            <div class="label">Alternativas Corretas:</div>
            <v-select
              v-model="alternativesCorrects"
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
              v-model="alternativesIncorrects"
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
      alternativesCorrects: [],
      alternativesIncorrects: [],
      subtitleItems: [],
      wrongItems: [],
      correctItems: [],
      words: []
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
      return this.alternativesIncorrects.length + this.alternativesCorrects.length < 4
    },
    searchTypes() {
      return this.typesArray([
        'substantivo_proprio',
        'substantivo_comum',
        'numero'
      ])
    },
    validate() {
      return this.alternativesCorrects.length > 1 && this.alternativesIncorrects.length > 1
    }
  },
  methods: {
    addItemIncorrect(alternatives) {
      const incorrects = alternatives.map((item) => {
        const text = item.text ? item.text : item;
        return new Item('value', this.WordTypes.input_custom.key, text)
      })
      this.alternativesIncorrects = incorrects
      this.concatItems()
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
      this.alternativesCorrects = corrects
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
    },
    updateSubtitle(subtitle) {
      this.$emit('updateSubtitle', subtitle)
    },
    concatItems() {
      this.items = [
        ...this.alternativesCorrects,
        ...this.alternativesIncorrects,
        ...this.subtitleItems
      ]
    },
    clearWords() {
      this.words = []
    },
    validateItems() {
      this.$emit('validateItems', this.items.length > 3)
    }
  }
}
</script>

<style lang="scss">
#alternativa-texto-subtitulo {
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
