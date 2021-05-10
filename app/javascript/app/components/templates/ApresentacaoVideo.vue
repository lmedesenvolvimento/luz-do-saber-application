<template>
  <div class="row">
    <div class="col-md-7">
      <div class="form-group has-feedback" :class="{ 'has-error': (theKey.word_text.length && !isValid) }">
        <label>Vídeo: </label>
        <input
          v-model="theKey.word_text"
          placeholder="Link do Vídeo"
          class="form-control"
          @change="onChangeItemValue"
        />
      </div>
    </div>
    <div class="col-md-5"></div>
  </div>
</template>

<script>
import Item from '../../models/Item'
import { WordTypes } from '../../types'
import TemplateMixin from '../../mixins/TemplateMixin'
export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [
        new Item('key', WordTypes.youtube.value, '')
      ]
    }
  },
  computed: {
    isValid() {
      return /^https?\:\/\//.test(this.theKey.word_text)
    }
  },
  watch: {
    isValid(){
      this.$emit('validateItems', this.isValid)
    }
  }
}
</script>

<style lang="scss" scoped>
.form-group{
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