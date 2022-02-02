<template>
  <div id="template-subtitulo" class="template-order container-fluid"></div>
</template>

<script>
import objectToFormData from 'object-to-formdata'
import { omit } from 'lodash'
const unpermitted_params = [
  'id',
  'total_syllables',
  'syllables',
  'info',
  'images',
  'audios'
]

export default {
  data() {
    return {
      input: null,
      description: {},
      image: {},
      errors: {}
    }
  },
  methods: {
    updateSubtitulo(event) {
      this.input = event.target.value
      this.$emit('change', this.input)
    },
    async submitImage() {
      await this.submit()
    },
    async submit() {
      const payload = this.mapWord()
      const formBody = objectToFormData(payload, { indices: true })

      try {
        const { data } = await this.$axios({
          url: '/words.json',
          method: 'post',
          data: formBody,
          headers: { 'Content-Type': 'multipart/form-data' }
        })

        if (data.errors) {
          const message = ActiveRecordHelper.errorMessage(data.errors)
          throw new Error(message)
        }
        this.input.image = data.images
        this.$emit('change', this.input)
      } catch (error) {
        console.log(error)
      }
    },
    mapWord() {
      let payload = { word: {} }

      if (this.image.attachment) {
        payload.word.images_attributes = [omit(this.image, ['url'])]
      }

      payload.word = omit(payload.word, unpermitted_params)
      payload.word.type = 'input_custom'

      const letters = '0123456789ABCDEFGHIJKLMNOPQRSTUVXZ'
      let prefix = 'IMAGE-'
      for (let i = 0; i < 10; i++) {
        prefix += letters[Math.floor(Math.random() * 33)]
      }
      payload.word.text = prefix

      return payload
    }
  }
}
</script>

<style lang="scss" scoped>
.template-order {
  @include template-editor-field;
}
</style>
