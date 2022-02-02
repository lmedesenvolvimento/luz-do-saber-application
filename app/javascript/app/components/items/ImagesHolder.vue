<template>
  <div class="ls-images-holder">
    <div class="img-holder" :class="size">
      <div v-for="item in items" :key="item.word_text">
        <div class="imgs" @click="editWord(item)">
          <img :src="getSrcImage(item)" @error="getDefaultImage" />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex'
import { WordTypes } from '../../types'

export default {
  props: {
    items: {
      type: Array,
      required: true
    },
    size: {
      type: String,
      default: 'medium'
    }
  },
  methods: {
    async editWord(item) {
      //const word_type = WordTypes[item.word_type]?.value
      const response = await this.$axios.get(
        `/words.json?q[type_eq]=${item.word_type}&q[text_eq]=${item.word_text}`
      )
      const word = response.data[0]

      this.setWord(word)

      this.$nextTick(() => {
        this.$modal.show('edit-word-images')
      })
    },
    getDefaultImage(event) {
      event.target.src = 'https://via.placeholder.com/150'
    },
    getSrcImage(item) {
      // temporario (até corrigir o remote_image_url)
      if (typeof item.remote_image_url === 'string')
        return item.remote_image_url
      else if (item.remote_image_url) return item.remote_image_url.url
      else if (item.url) return item.url
      else return 'https://via.placeholder.com/150'
    },
    ...mapActions(['setWord'])
  }
}
</script>
<style lang="scss">
.img-holder {
  height: 120px;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  max-width: 100%;
  overflow-x: auto;
  overflow-y: hidden;
  .imgs {
    position: relative;
    border: 2px solid #11a7a2;
    border-radius: 5px;
    padding: 2px;
    background: white;
    margin: 5px;
    &:first-child {
      margin-left: 0px;
    }
    .edit-image {
      position: absolute;
      top: 4px;
      left: 4px;
    }
  }
  &.medium {
    height: 88px;
    img {
      height: 80px;
      min-width: 100px;
      max-width: 120px;
    }
  }
  &.large {
    height: 176px;
    img {
      height: 160px;
      min-width: 200px;
      max-width: 240px;
    }
  }
}
</style>
