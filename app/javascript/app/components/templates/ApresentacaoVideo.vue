<template>
  <div class="row">
    <div class="col-md-7">
      <div
        class="form-group has-feedback"
        :class="{ 'has-error': link.length && !isValid }"
      >
        <label>Vídeo: </label>
        <input
          v-model="link"
          placeholder="Link do Vídeo"
          class="form-control"
          @change="changeLink(link)"
        />
      </div>
    </div>
    <div class="col-md-5"></div>
  </div>
</template>

<script>
import Vue from 'vue'
import Item from '../../models/Item'
import { WordTypes } from '../../types'
import TemplateMixin from '../../mixins/TemplateMixin'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [new Item('key', WordTypes.youtube.value, '')],
      link: ''
    }
  },
  mounted() {
    if (this.isEditing) {
      this.link = this.theKey.word_text
    }
  },
  computed: {
    isValid() {
      return /^https?\:\/\//.test(this.link)
    }
  },
  methods: {
    changeLink(item) {
      const items = [new Item('key', WordTypes.youtube.value, item)]
      Vue.set(this, 'items', items)
    }
  },
  watch: {
    isValid() {
      this.$emit('validateItems', this.isValid)
    }
  }
}
</script>

<style lang="scss" scoped>
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
</style>
