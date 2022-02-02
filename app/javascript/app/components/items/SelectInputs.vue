<template>
  <div class="ls-select-letters container-fluid">
    <div v-if="lettersVisibility" class="letters">
      <label v-for="l in filteredLetters" :key="l.id">
        <div
          class="panel letter"
          :class="{ 'panel-primary': l.selected, 'panel-default': !l.selected }"
        >
          <div class="panel-body">
            {{ l.text }}
            <input
              v-model="l.selected"
              class="invisible"
              type="checkbox"
              :id="l.id"
              @input="!l.selected"
              :disabled="disabled && !l.selected"
            />
          </div>
        </div>
      </label>
    </div>
    <div
      v-show="this.letters.length"
      class="ls-select-letters-progress"
      :class="{ invalid: invalid }"
    >
      <div
        v-for="(s, index) in totalSteps"
        :key="s"
        class="step"
        :class="{ completed: completedSteps > index }"
      ></div>
    </div>
    <div v-if="invalid" class="ls-select-letters-feedback">
      Você excedeu o limite máximo de letras a serem selecionadas
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import { range } from "lodash";
export default {
  props: {
    maxItems: {
      type: Number,
      default: 3,
    },
    removerLetra: {
      type: String,
      default: null,
    },
    initialLetras: {
      type: Array,
      default: () => {
        return [];
      },
    },
    values: {
      type: Array,
      required: true,
    }
  },
  data() {
    return {
      letters: [],
      lettersVisibility: true,
    };
  },
  computed: {
    invalid() {
      return this.completedSteps > this.maxItems;
    },
    totalSteps() {
      return range(0, this.maxItems);
    },
    completedSteps() {
      return this.letters.filter((l) => l.selected).length;
    },
    disabled() {
      return this.completedSteps >= this.maxItems;
    },
    filteredLetters() {
      return this.letters.filter((val) => val.text)
    }
  },
  watch: {
    letters: {
      handler() {
        const data = this.letters
          .filter((l) => !!l.selected)
          .slice(0, this.maxItems);
        this.$emit("change", { data, invalid: this.invalid });
      },
      deep: true,
    },
    values: {
      handler(newValue) {
        const newValues = this.letters.filter((l) => !newValue.includes(l))
        if (newValues.length) {
          this.letters.push(...newValues);
          this.sortLetters();
        }
      },
      deep: true,
    }
  },
  methods: {
    changeSelect(el) {
      !el.selected;
    },
    sortLetters() {
      this.letters.sort(function(a, b) {
        if (a.text > b.text) {
          return 1;
        }
        if (a.text < b.text) {
          return -1;
        }
        return 0;
      });
    },
  },
  created() {
    this.letters = this.values
    if (this.removerLetra) {
      const filteredLetters = this.letters.filter(
        ({ text }) => text !== this.removerLetra
      );
      this.letters = filteredLetters;
    }

    this.letters.map((current, index) => {
      if (this.initialLetras.includes(current.text)) {
        this.letters[index].selected = true;
      }
    });


  },
};
</script>

<style lang="scss">
.ls-select-letters {
  .letters {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-start;
    box-sizing: border-box;
    padding: 0px ($gap * 1.25);
  }
  label {
    display: inline-block;
    width: auto;
    max-width: $gap * 12;
    padding: 0px ($gap * 0.5);
    margin: 0px;
    &:hover {
      cursor: pointer;
    }
  }
  .letter {
    width: max-content;
    height: $gap * 5;
    border-radius: $gap * 0.5;
    margin: ($gap * 0.5) auto;
    border-width: 2px;
    .panel-body {
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
  &-feedback {
    color: $brand-danger;
    font-weight: bold;
    font-size: 10px;
    text-align: center;
  }
}
</style>
