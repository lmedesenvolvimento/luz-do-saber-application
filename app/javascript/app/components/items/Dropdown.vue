<template>
  <div
    class="dropdown"
    @click="toggleRiskLevels"
    :class="{ expanded: isExpanded }"
    :style="computedStyles"
  >
    <div class="dropdown-label-container">
      <div class="dropdown-label">
        <span class="text">
          {{ (config.prefix ? config.prefix : '') + ' '
          }}{{ config.placeholder ? config.placeholder : '' }}
        </span>
        <i class="angle-down" :class="{ toggled: isExpanded }"></i>
      </div>
    </div>

    <div v-expand="isExpanded" class="options expand">
      <div
        v-for="option in configOptions"
        v-show="option"
        class="option"
        @click="setCurrentSelectedOption(option)"
      >
        {{ option ? option.value : '' }}
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      isBottomSectionToggled: false,
      optionsHeight: 60,
      optionHeight: 40,
      width: 170,
      configOptions: [],
      backgroundColor: 'none',
      backgroundExpandedColor: 'none',
      hoverBackgroundColor: '#dfdfdf',
      border: 'none',
      borderRadius: 0,
      textColor: '#333333',
      isExpanded: false
    }
  },
  components: {},
  props: {
    config: {
      type: Object,
      default: () => {}
    }
  },
  computed: {
    computedStyles: function() {
      return [
        { '--options-height': this.optionsHeight + 'px' },
        { '--options-height-neg': '-' + this.optionsHeight + 'px' },
        { '--option-height': this.optionHeight + 'px' },
        { '--main-el-border-radius': this.borderRadius },
        { '--dropdown-width': this.width + 'px' },
        { '--dropdown-background-color': this.backgroundColor },
        { '--dropdown-expanded-color': this.backgroundExpandedColor },
        { '--dropdown-border': this.border },
        { '--dropdown-hover-background-color': this.hoverBackgroundColor },
        { '--dropdown-default-text-color': this.textColor }
      ]
    }
  },
  directives: {
    expand: {
      inserted: function(el, binding) {
        if (binding.value !== null) {
          function calcHeight() {
            const currentState = el.getAttribute('aria-expanded')
            el.classList.add('u-no-transition')
            el.removeAttribute('aria-expanded')
            el.style.height = null
            el.style.height = el.clientHeight + 'px'
            el.setAttribute('aria-expanded', currentState)

            setTimeout(function() {
              el.classList.remove('u-no-transition')
            })
          }
          el.classList.add('expand')
          el.setAttribute('aria-expanded', binding.value ? 'true' : 'false')
          calcHeight()
          window.addEventListener('resize', calcHeight)
        }
      },
      update: function(el, binding) {
        if (el.style.height && binding.value !== null) {
          el.setAttribute('aria-expanded', binding.value ? 'true' : 'false')
        }
      }
    }
  },
  methods: {
    toggleRiskLevels() {
      this.isExpanded = !this.isExpanded
    },
    setCurrentSelectedOption(option) {
      this.$emit('setSelectedOption', option)
    },
    setConfigData() {
      this.configOptions = this.config.options
      if (this.config.width) this.width = this.config.width
      if (this.config.backgroundColor) {
        this.backgroundColor = this.config.backgroundColor
      }
      if (this.config.backgroundExpandedColor) {
        this.backgroundExpandedColor = this.config.backgroundExpandedColor
      }
      if (this.config.border) {
        this.border = this.config.border
      }
      if (this.config.hoverBackgroundColor) {
        this.hoverBackgroundColor = this.config.hoverBackgroundColor
      }
      if (this.config.textColor) {
        this.textColor = this.config.textColor
      }
      if (this.config.borderRadius) {
        this.borderRadius = this.config.borderRadius
      }
    },
    setOptionsHeight() {
      this.optionsHeight = this.optionHeight * this.configOptions.length
    }
  },
  created() {
    this.setConfigData()
    this.setOptionsHeight()
  },
  beforeUdate() {
    // this.setOptionsHeight();
  },
  mounted() {}
}
</script>

<style lang="scss" scoped>
$default-text-hover-color: black;
$default-hover-color: #dfdfdf;
$default-text-color: #fff;
$option-padding: 4px 10px;

.dropdown {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-direction: column;
  width: var(--dropdown-width);
  position: relative;
  cursor: pointer;
  color: var(--dropdown-default-text-color);

  user-select: none;
  transition: all 0.7s linear;
  .dropdown-label-container {
    display: flex;
    width: 100%;
    .dropdown-label {
      display: flex;
      flex: 1 1 auto;
      align-items: center;
      height: var(--option-height);
      padding: 4px 10px 4px 1px;
      .text {
        color: $grey-light-3;
        font-weight: 400;
        margin-right: $gap * 2;
        height: 20px;
        text-overflow: ellipsis;
        width: 100%;
        overflow: hidden;
        line-height: 14px;
        height: 26px;
        display: flex;
        align-items: center;
      }
      .angle-down {
        display: flex;
        justify-content: center;
        align-items: center;
        border: solid $default-text-color;
        background: transparent;
        border-width: 0 3px 3px 0;
        padding: 4px;
        width: 1px;
        height: 1px;
        margin: -3px 5px 0 0;
        border-color: $brand-primary;
        transform: rotate(45deg);
        transition: all 0.7s;
      }
      .toggled {
        margin-bottom: -12px;
        transform: rotate(-135deg);
        transition: all 0.7s;
      }
    }
  }

  .options {
    width: 100%;
    box-shadow: $box-shadown;
    background: white;
    position: absolute;
    top: 41px;
    .option {
      display: flex;
      align-items: center;
      padding: 10px 14px;
      color: $grey-light-3;
      font-weight: 400;
      line-height: 15px;
    }
    .option:hover {
      color: $default-text-hover-color;
      background: $default-hover-color;
      transition: all 0.7s;
    }
    .option:last-child {
      border-radius: 0 0 var(--main-el-border-radius)
        var(--main-el-border-radius);
    }
    .option:last-child:hover {
      border-radius: 0 0 var(--main-el-border-radius)
        var(--main-el-border-radius);
    }
  }
}
.dropdown.expanded {
  background: var(--dropdown-expanded-color);
  border: var(--dropdown-border);
  transition: all 0.7s linear;
}

// Expand Class - Most important part
.expand {
  overflow: hidden;
  transition-property: height;
  transition-duration: 0.4s; // Durations can be changed without touching JS
  transition-timing-function: cubic-bezier(
    0.175,
    0.885,
    0.32,
    1.275
  ); // Timing functions also!

  &[aria-expanded='false'] {
    height: 0 !important;
    transition-timing-function: cubic-bezier(
      0.6,
      -0.28,
      0.735,
      0.045
    ); // Timing function can be different for each direction
  }
}

// Smartphones - Landscape + Portrait
@media only screen and (min-device-width: 320px) and (max-device-width: 480px) {
}
</style>
