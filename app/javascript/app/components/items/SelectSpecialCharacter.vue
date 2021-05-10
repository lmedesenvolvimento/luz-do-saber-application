<template>
  <div class="ls-select-character container-fluid">
    <div class="character">
      <label v-for="l in character" :key="l.id">
        <div class="panel letter" :class="{'panel-primary': l.selected, 'panel-default': !l.selected}">
          <div class="panel-body">
            {{ l.text }}
            <input v-model="l.selected" class="invisible" type="checkbox" />
          </div>
        </div>
      </label>
    </div>
    <div 
      v-show="this.character.length"
      class="ls-select-character-progress" 
      :class="{'invalid': invalid}"
    >
      <div 
        v-for="(s, index) in totalSteps" 
        :key="s" 
        class="step" 
        :class="{ 'completed': completedSteps > index }"
      ></div>
    </div>
    <div v-if="invalid" class="ls-select-character-feedback">
      Você excedeu o limite máximo de caracteres a serem selecionados
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { range } from 'lodash'
export default {
  props: {
    maxItems: {
      type: Number,
      default: 3
    }
  },
  data() {
    return {
      character: []
    }
  },
  computed: {
    invalid(){
      return this.completedSteps > this.maxItems
    },
    totalSteps() {
      return range(0, this.maxItems)
    },
    completedSteps() {
      return this.character.filter(l => l.selected).length
    }
  },  
  watch: {
    character: {
      handler() {
        const data = this.character.filter(l => !!l.selected).slice(0, this.maxItems)
        this.$emit('change', { data, invalid: this.invalid })
      },
      deep: true
    }
  },
  async created() {
    const { data } = await this.$axios.get('/words.json?q[type_eq]=7')
    this.character = data
  }
}
</script>

<style lang="scss">
.ls-select-character {
  .character {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-start;
    box-sizing: border-box;
    padding: 0px ($gap * 1.25);
  }
  label {
    display: inline-block;
    width: auto;
    max-width: $gap * 6;
    padding: 0px ($gap * 0.5);
    margin: 0px;
    &:hover {
      cursor: pointer;
    }
  }
  .letter{
    width: $gap * 5;
    height: $gap * 5;
    border-radius: $gap * 0.5;
    margin: ($gap * 0.5) auto;
    border-width: 2px;
    .panel-body{
      width: 100%;
      padding: $gap;
      font-size: 16px;
      font-weight: bold;
      text-align: center;
    }
  }
  .invisible {
    margin: 0px;
    padding: 0px;
    width: 0px;
    height: 0px;
  }
  &-progress {
    display: flex;
    flex-wrap: nowrap;
    width: 100%;
    margin: ($gap * 2) 0px;
    &.invalid {
      .step.completed {
        background-color: $brand-danger;
      }
    }
    .step {
      flex: 1;
      height: $gap * 0.5;
      background-color: $border-color;
      border: 1px solid darken($color: $border-color, $amount: 5);
      margin: 0px 1px;
      &.completed {
        background-color: $brand-primary;
      }
    }
  }
  &-feedback{
    color: $brand-danger;
    font-weight: bold;
    font-size: 10px;
    text-align: center;
  }
}
</style>