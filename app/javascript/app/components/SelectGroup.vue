<template>
  <v-select 
    :value="input" 
    :options="groups"
    placeholder="Selecionar"
    label="name"
    @input="onChangeValue"
  />
</template>

<script>
import axios from 'axios'
export default {
  model: {
    prop: 'input',
    event: 'change'
  },
  props: {
    input: null,
    groups: {
      type: null,
      default: []
    }
  },
  methods: {    
    onChangeValue(value){
      this.$emit('change', value)
    }
  }  
}
</script>

<style>

</style>