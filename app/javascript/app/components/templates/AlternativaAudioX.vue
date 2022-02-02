<template>
  <div id="alternativa-audio-x">
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
    <div class="alternativa-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="alternativa-items-input-group"
            :options="words"
            :max-items="1"
            :label="'Palavra Correta:'"
            :initial-items="initialCorreta"
            :searchable="alternativaCorreta.length < 1"
            :label-html="true"
            @search="onSearch"
            @input="inputCorreta"
            v-model="input"
          />
          <div>(1 Item)</div>
        </div>
        <div class="col-md-5">
          <ls-audio-player :audio-url="getAudioUrl"></ls-audio-player>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="alternativa-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            ref="select"
            class="alternativa-items-input-group"
            :options="words"
            :max-items="maxItems"
            :label="'Palavras Incorretas:'"
            :initial-items="initialIncorretas"
            :searchable="alternativaIncorretas.length < 3"
            :label-html="true"
            @search="onSearch"
            @input="inputAlternativaItem"
          />
          <div>(3 Items)</div>
        </div>
        <div class="col-md-5"></div>
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
      alternativaIncorretas: [],
      alternativaCorreta: [],
      allAlt: [],
      initialCorreta: [],
      initialIncorretas: [],
      input: []
    }
  },
  created() {
    if (this.isEditing) {
      this.allAlt = this.items
      this.items.map((el, index) => {
        if (el.type === 'key') {
          this.initialCorreta.push({ text: el.text })
          this.alternativaCorreta.push(el)
        } else {
          this.initialIncorretas.push({ text: el.text })
          this.alternativaIncorretas.push(el)
        }
      })
    }
  },
  async mounted() {
    if (this.items.length > 0 && this.isEditing) {
      this.items.map(async el => {
        if (el.type === 'key') {
          const response = await this.$axios.get(
            `/words.json?q[type_eq]=${el.word_type}&q[text_cont]=${el.text}`
          )
          this.input = response.data
        }
      })
    }
  },
  computed: {
    types() {
      return values(WordTypes).filter(t => templateTypes.includes(t.value))
    },
    getAudioUrl() {
      return this.input[0] ? `${this.input[0].audios[0].url}` : null
    }
  },
  methods: {
    inputAlternativaItem(alternatives) {
      this.input = alternatives
      const items = alternatives.map(({ text }) => {
        return new Item('value', this.WordTypes.substantivo_comum.value, text)
      })

      this.alternativaIncorretas = items
      this.allAlt = this.alternativaIncorretas.concat(this.alternativaCorreta)
      if (this.allAlt.length === 4) {
        Vue.set(this, 'items', this.allAlt)
      }
    },
    inputCorreta(alternatives) {
      const items = alternatives.map(({ text }) => {
        return new Item('key', this.WordTypes.substantivo_comum.value, text)
      })
      this.alternativaCorreta = items
      this.allAlt = this.alternativaIncorretas.concat(this.alternativaCorreta)
      if (this.allAlt.length === 4) {
        Vue.set(this, 'items', this.allAlt)
      }
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
#alternativa-audio-x {
  .alternativa-items,
  .type {
    @include template-editor-field;
    margin: $gap 0px;
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
