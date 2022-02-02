<template>
  <div id="meu-cracha"></div>
</template>

<script>
import Vue from 'vue'
import Item from '../../models/Item'
import { WordTypes } from '../../types'

import TemplateMixin from '../../mixins/TemplateMixin.vue'

export default {
  mixins: [TemplateMixin],
  created() {
    const newItem = new Item()

    newItem.type = 'key'
    newItem.word_type = WordTypes.substantivo_proprio.value
    newItem.word_source_type = 'external_param'

    this.items.push(newItem)

    this.$emit('validateItems', true)
  }
}
</script>

<style lang="scss">
#meu-cracha {
  .alternative {
    @include template-editor-field;
  }
}
</style>
