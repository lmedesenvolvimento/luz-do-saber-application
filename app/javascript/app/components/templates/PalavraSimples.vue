<template>
  <div id="palavra-simples">
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
    <div class="alternatives">
      <div class="row">
        <div class="col-md-7">
          <div class="alternatives-input-group">
            <label class="label">Palavra</label>
            <ls-select-word
              v-model="theKey.word_text"
              @input="onInput"
              :type="type"
            />
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { values } from 'lodash'
import { WordTypes } from '../../types'
import TemplateMixin from '../../mixins/TemplateMixin'
import Item from '../../models/Item'

const templateTypes = [
  WordTypes.substantivo_comum.value,
  WordTypes.substantivo_proprio.value
]

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.substantivo_comum,
      items: [],
      invalid: false
    }
  },
  computed: {
    types() {
      return values(WordTypes).filter((t) => templateTypes.includes(t.value))
    }
  },
  methods: {
    createItems() {
      const items = []

      items.push(new Item('key', this.word_type.value, ''))

      Vue.set(this, 'items', items)
    },
    onInput(el) {
      if (this.theKey) {
        this.theKey.text = el.text
        this.theKey.word_type = this.word_type.value

        let imagemUrl = null
        if (el.images.length > 0) imagemUrl = el.images[0].url

        const value_items_attributes = [
          new Item('value', this.word_type.value, el.text)
        ]

        const itemTemp = new Item(
          'key',
          this.word_type.value,
          el.text,
          imagemUrl
        )
        Vue.set(this, 'items', [itemTemp])
      }
    },
    validateItems() {
      this.$emit('validateItems', !!this.theKey.word_text)
    }
  },
  watch: {
    word_type() {
      if (!this.isEditing) this.createItems()
    }
  },
  created() {
    if (!this.isEditing) {
      this.createItems()
    }
  },
  mounted() {
    if (this.isEditing) {
      if (this.theKey.word_type === 2) {
        this.word_type = WordTypes.substantivo_proprio
      } else {
        this.word_type = WordTypes.substantivo_comum
      }
    }
  }
}
</script>

<style lang="scss">
#palavra-simples {
  .type,
  .alternatives {
    @include template-editor-field;
  }
  .alternatives {
    .label {
      align-self: flex-start;
    }
  }
}
</style>
