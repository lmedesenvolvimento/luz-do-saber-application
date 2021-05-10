<template>
  <v-select
    v-if="theme && theme.units"
    :value="input"
    :options="sortedArray"
    placeholder="Selecionar"
    label="title"
    @input="onChangeValue"
    :disabled="!theme"
  />
  <v-select
    v-else
    :options="[]"
    placeholder="Selecionar"
    label="title"
    :disabled="!theme"
  />
</template>

<script>
import axios from "axios";
export default {
  model: {
    prop: "input",
    event: "change",
  },
  props: {
    input: null,
    theme: null,
  },
  computed: {
    sortedArray: function () {
      function compare(a, b) {
        if (a.title < b.title) return -1;
        if (a.title > b.title) return 1;
        return 0;
      }

      return this.theme.units.sort(compare);
    },
  },
  methods: {
    onChangeValue(value) {
      this.$emit("change", value);
    },
  },
};
</script>

<style>
</style>