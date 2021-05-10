<template>
  <v-select
    :value="input"
    :options="sortedArray"
    placeholder="Selecionar"
    label="title"
    @input="onChangeValue"
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
  },
  data() {
    return {
      options: [],
    };
  },
  async mounted() {
    const { data } = await this.$axios.get("/themes.json");
    this.options = data;
  },
  updated() {
    //console.log(this.options);
  },
  computed: {
    sortedArray: function () {
      function compare(a, b) {
        if (a.title < b.title) return -1;
        if (a.title > b.title) return 1;
        return 0;
      }
      return this.options.sort(compare);
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