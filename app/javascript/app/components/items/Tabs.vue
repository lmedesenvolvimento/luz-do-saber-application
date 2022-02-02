<template>
  <div>
    <div v-if="title" class="tabs-title">{{ title }}</div>
    <ul class="tabs-header" :style="[marginStyle, paddingStyle]">
      <li
        v-for="(tab, index) in tabs"
        :key="tab.title"
        @click="selectTab(index)"
        :class="{ 'tab-selected': index == selectedIndex }"
      >
        {{ tab.title }}
      </li>
    </ul>
    <slot></slot>
  </div>
</template>

<script>
export default {
  props: {
    margin: {
      type: [Number, String],
      default: -48
    },
    title: {
      type: String,
      default: null
    },
    padding: {
      type: [Number, String],
      default: null
    }
  },
  data() {
    return {
      selectedIndex: 0,
      tabs: []
    }
  },
  computed: {
    marginStyle() {
      return {
        margin: `0 ${this.margin}px`,
        paddingLeft: `${this.margin * -1}px`
      }
    },
    paddingStyle() {
      if (this.padding)
        return {
          paddingLeft: `${this.padding}px`
        }
    }
  },
  created() {
    this.tabs = this.$children
  },
  mounted() {
    this.selectTab(0)
  },
  methods: {
    selectTab(i) {
      this.selectedIndex = i
      this.$emit('change')
      // loop over all the tabs
      this.tabs.forEach((tab, index) => {
        tab.isActive = index === i
      })
    }
  }
}
</script>

<style scoped lang="scss">
.tabs-title {
  background-color: $brand-primary;
  color: white;
  padding: $gap * 1.5 $gap * 4;
  text-transform: uppercase;
}
.tabs-header {
  display: block;
  list-style: none;
  padding: 0;
  background-color: $grey-light;
  border-bottom: 1px solid #dcdcdc;

  li {
    text-transform: uppercase;
    color: $grey-light-3;
    padding: 15px 20px;
    margin: 0 15px;
    display: inline-block;
    margin-right: 5px;
    cursor: pointer;
    position: relative;
    font-weight: 600;

    &:first-child {
      margin: 0 15px 0 0;
    }

    &.tab-selected {
      color: $brand-primary;
      // border-bottom: 4px solid $brand-primary;
      &:after {
        content: '';
        display: block;
        width: 100%;
        height: 5px;
        border-radius: 5px;
        background: $brand-primary;
        position: absolute;
        bottom: 0;
        left: 0;
      }
    }
  }
}
</style>
