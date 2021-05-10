<template>
  <div class="ls-input-number-syllables">  
    <div class="btn-group" role="group">
      <button @click="decrement" type="button" class="btn btn-default btn-sm">-</button>
      <button type="button" class="btn btn-default btn-sm">{{ input }}</button>
      <button @click="increment" type="button" class="btn btn-default btn-sm">+</button>
    </div>  
  </div>
</template>

<script>
export default {
  model: {
    prop: 'input',
    event: 'change'
  },
  props: {
    input: {
      type: Number,
      default: 1
    }
  },
  methods: {
    increment(){
      if (this.input < 10) {
        this.$emit('change', (this.input + 1))
      }
    },
    decrement(){
      if (this.input > 1) {
        this.$emit('change', (this.input - 1))
      }
    }
  }
}
</script>

<style lang="scss">
.ls-input-number-syllables {
  .btn {
    font-weight: bold;
    &:nth-child(2){
      color: $text-color;
      padding-left: $gap * 3;
      padding-right: $gap * 3;
    }
  }
}
</style>