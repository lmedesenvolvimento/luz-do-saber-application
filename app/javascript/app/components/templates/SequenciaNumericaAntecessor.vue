<template>
  <div id="sequencia-numerica">
    <div class="sequence-numbers">
      <div class="row">
        <div class="col-md-7">
          <div class="sequence-numbers-input-group">
            <label class="label is-top">Sequência:</label>
            <span class="input-number-group">
              <div
                v-for="input in inputsNumbers"
                :key="input.index"
                class="input-number"
              >
                <input
                  v-model="input.text"
                  type="number"
                  min="-999"
                  max="999"
                  @keypress="isNumber"
                />
              </div>
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="numbers-alternatives">
      <div class="row">
        <div class="col-md-7">
          <div class="hide-numbers-input-group">
            <label class="label is-top"
              >Número de <br />
              distratores:</label
            >
            <span class="input">
              <v-select
                :value="distratores"
                :options="numbersOptions"
                label="name"
                @input="onChangeValue"
              />
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import TemplateMixin from '../../mixins/TemplateMixin'
import Item from '../../models/Item'
import { WordTypes } from '../../types'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      busy: false,
      word_type: WordTypes.input_custom.value,
      inputsNumbers: [],
      hideNumbers: [],
      itemsSelected: [],
      items: [],
      distratores: 0,
      numbersOptions: [5, 6, 7, 8, 9, 10],
      distOptions: []
    }
  },
  computed: {
    validate() {
      return this.items.filter(({ type }) => type === 'key').length === 3
    }
  },
  created() {
    this.inputsNumbers = this.fillUntilValue(2, { text: '' })
  },
  watch: {
    inputsNumbers: {
      handler(data) {
        if (data.length <= 0) return false

        this.items = this.inputsNumbers
          .map(({ text }, index) => {
            if (!text) return
            if (index === 1) {
              return new Item('key', this.word_type, text)
            } else {
              const value_items_attributes = new Item(
                'value',
                this.word_type,
                text
              )
              return new Item('key', this.word_type, text, null, [
                value_items_attributes
              ])
            }
          })
          .filter(item => item)

        this.onChangeValue(this.distratores)
        this.itemsSelected = this.items

        Vue.set(this, 'items', this.items)
      },
      deep: true
    }
  },
  methods: {
    validateItems() {
      this.$emit('validateItems', this.validate)
    },
    fillUntilValue(target, value) {
      const array = []
      for (let i = 0; i < target + 1; i++) {
        const obj = { ...value, index: i }
        array.push(obj)
      }
      return array
    },
    onChangeValue(input) {
      const numberSelected = this.inputsNumbers
        .map(({ text }) => Number(text))
        .sort((a, b) => a > b)
      this.distratores = input
      if (input > 0 && numberSelected.length > 0) {
        let options = []
        const hasNegative = numberSelected.some(value => value < 0)
        const firstNumber = numberSelected[0] - 10
        const lastNumber = numberSelected[numberSelected.length - 1] + 10
        const totalFor = lastNumber - firstNumber
        for (let i = 0; i < totalFor; i++) {
          options.push(firstNumber + i)
        }
        if (!hasNegative) options = options.filter(num => num >= 0)
        options = options.filter(num => !numberSelected.includes(num))
        options = this.getSampleSize(options, input)
        options = options.map(
          number => new Item('value', this.word_type, number.toString())
        )

        this.items = [...this.itemsSelected, ...options]

        Vue.set(this, 'items', this.items)
      }
    },
    isNumber(evt) {
      const number = evt.target.value
      const hasDecimal = number.includes('.') || number.includes(',')
      const isThreeDigit = Number(number) >= 100 || Number(number) <= -100
      const totalDigits = hasDecimal ? number.split('.')[1].length : 0
      const keyPressed = evt.key

      let keysAllowed = [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '.',
        ',',
        '-'
      ]

      if (number !== '')
        keysAllowed = [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '.',
          ','
        ]

      if (hasDecimal)
        keysAllowed = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

      if (isThreeDigit && !hasDecimal) keysAllowed = ['.', ',']

      if (totalDigits > 2) evt.preventDefault()

      if (!keysAllowed.includes(keyPressed)) evt.preventDefault()
    },
    randomNear(array, index = -1) {
      if (index > 0) {
        return array[index] + getRandomFromIt([-1, 1])
      }
    },
    getRandomFromIt(arr) {
      return arr[Math.floor(Math.random() * arr.length)]
    },
    randomIntFromInterval(min, max) {
      return Math.floor(Math.random() * (max - min + 1) + min)
    },
    shuffle(array) {
      for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1))
        ;[array[i], array[j]] = [array[j], array[i]]
      }
      return array
    },
    getSampleSize(arr, sizeOfSample) {
      if (sizeOfSample <= arr.length) {
        const shuffledArr = this.shuffle(arr)
        return shuffledArr.slice(0, sizeOfSample)
      } else {
        const shuffledArr = []
        const times = {
          integer: Math.floor(sizeOfSample / arr.length),
          mod: sizeOfSample % arr.length
        }
        for (let i = 0; i < times.integer; i++) {
          shuffledArr.push(...this.shuffle(arr))
        }
        shuffledArr.push(...this.shuffle(arr).slice(0, times.mod))
        return shuffledArr
      }
    }
  }
}
</script>

<style lang="scss">
#sequencia-numerica {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }
  .type,
  .alternatives {
    @include template-editor-field;
  }
  .alternatives {
    .label {
      align-self: flex-start;
    }
  }
  .sequence-numbers,
  .hide-numbers {
    @include template-editor-field;
    .input-number-group {
      display: flex;
      flex-wrap: wrap;
      width: 460px;
    }
    .input-number {
      margin: 5px 10px;
      input {
        width: 50px;
        border: 2px solid #ddd;
        text-align: center;
        border-radius: 5px;
        font-size: 20px;
      }
      /* Chrome, Safari, Edge, Opera */
      input::-webkit-outer-spin-button,
      input::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
      }

      /* Firefox */
      input[type='number'] {
        -moz-appearance: textfield;
      }
    }
  }
}
</style>
