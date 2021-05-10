<template>
  <div class="ls-input-syllables">
    <div class="ls-input-syllables-list">
      <div v-for="(syllable, index) in syllables" :key="index.toString()" class="ls-input-syllables-item">
        <input class="form-control" v-model="syllable.text" maxlength="4" />
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { range } from 'lodash'
export default {
  model: {
    prop: 'input',
    event: 'change'
  },
  props: {
    input: {
      type: Array,
      default: []
    },
    totalSyllables: {
      type: Number,
      default: 1
    }
  },
  data() {
    return {
      syllables: []
    }
  },
  methods: {
    mountSyllables(){
      const newSyllables = []
  
      range(0, this.totalSyllables).forEach((pos) => {
        const syllable = this.syllables[pos] ? this.syllables[pos] : { text: '' }
        newSyllables.push(syllable)
      })
  
      Vue.set(this, 'syllables', newSyllables)
    }
  },
  watch: {
    totalSyllables() {
      this.mountSyllables()
    },
    syllables: {
      handler(val){
        this.$emit('change', val)
      },
      deep: true
    }
  },
  created() {
    this.mountSyllables()
  }
}
</script>

<style lang="scss">
  .ls-input-syllables {
    padding: 0px;
    &-list{
      display: flex;
      flex-wrap: wrap;
      box-sizing: border-box;
      margin-left: -0.75rem;
      margin-right: -0.75rem;
    }
    &-item{
      padding: 0px 0.75rem;
      margin-bottom: 1rem;
      max-width: 25%;
      .form-control {
        width: 100%;
        padding: 6px ($gap * 2);
      }
    }
  }
</style>