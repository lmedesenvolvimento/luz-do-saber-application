<template>
  <div v-if="word" id="edit-images" class="ls-modal">
    <div class="ls-modal-form form-inline">
      <div class="ls-modal-header">
        <div class="title">Imagens - {{ word.text }}</div>
      </div>
      <div class="ls-modal-content">
        <div class="container-fluid">
          <div class="images">
            <div class="row">
              <div
                class="col-sm-4 text-center"
                v-for="(image, index) in word.images"
                :key="index"
              >
                <div class="image">
                  <img
                    @click.stop="select(image)"
                    class="img-fluid"
                    :src="image.url"
                  />
                  <div class="actions">
                    <!-- <button class="btn btn-link" @click.stop="remove(image, index)">Remover</button> -->
                  </div>
                </div>
              </div>
              <div class="col-sm-4 text-center" v-if="preview">
                <div class="image">
                  <img class="img-fluid" :src="preview" />
                  <div class="progress">
                    <div
                      class="progress-bar"
                      role="progressbar"
                      :aria-valuenow="progress"
                      aria-valuemin="0"
                      aria-valuemax="100"
                      :style="{ width: `${progress}%` }"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="well well-sm">
            <div class="form-group">
              <label>Selecione uma imagem do seu dispositivo </label>
              <input
                ref="file"
                type="file"
                class="form-control-file"
                accept="image/*"
                @change="handleFileUpload"
                :disabled="busy"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import objectToFormData from 'object-to-formdata'

export default {
  data() {
    return {
      file: null,
      preview: null,
      progress: 0,
      busy: false
    }
  },
  computed: {
    word: {
      get() {
        return this.$store.state.word
      },
      set(word) {
        this.$store.dispatch('setWord', word)
      }
    }
  },
  methods: {
    handleFileUpload() {
      this.file = this.$refs.file.files[0]
      this.preview = URL.createObjectURL(this.file)

      this.upload()
    },
    select(image) {
      this.$modal.hide('edit-word-images')
      this.$root.$emit('word:select:image', { word: this.word, image })
    },
    async remove(image, index) {
      const { id } = image
      const response = confirm('Deseja realmente apagar está imagem?')

      if (!response) {
        return false
      }

      this.word.images.splice(index, 1)

      const payload = {
        word: {
          images_attributes: [
            {
              id,
              _destroy: true
            }
          ]
        }
      }

     

      const reponse = await this.$axios({
        url: `/words/${this.word.id}.json`,
        method: 'put',
        data: payload
      })

      if (!reponse.data.success) {
        return alert(
          'Error desconhecido ao tentar remover imagem, por favor contate o administrador'
        )
      }
    },
    async upload() {
      this.busy = true

      const payload = {
        word: {
          images_attributes: [
            {
              attachment: this.file
            }
          ]
        }
      }

      const formBody = objectToFormData(payload, { indices: true })

      const reponse = await this.$axios({
        url: `/words/${this.word.id}.json`,
        method: 'put',
        data: formBody,
        headers: { 'Content-Type': 'multipart/form-data' },
        onUploadProgress: (event) => {
          this.progress = (event.loaded / this.file.size) * 100
        }
      })

      

      if (reponse.data.success) {
        try {
          const { data } = await this.$axios.get(`/words/${this.word.id}.json`)
          this.word = { ...this.word, ...data }
        } catch (error) {
          console.warn('Não foi possível persistir novos dados', error)
        } finally {
          this.file = null
          this.preview = null
          this.progress = 0
          this.busy = false

          /*
           * GARBAGE COLLECTOR
           */

          // Limpando arquivos do input
          this.$refs.file.value = ''

          // Removendo da memória preview
          URL.revokeObjectURL(this.preview)
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
#edit-images {
  img.img-fluid {
    display: inline-block;
    max-width: 100%;
  }
  .images {
    margin-bottom: 1.5rem;
    .row {
      display: flex;
      flex-wrap: wrap;
      align-items: stretch;
      box-sizing: border-box;
      [class^='col'] {
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
      }
    }
    .image {
      padding: $gap;
      border: 2px solid transparent;
      &:hover {
        border: 2px solid $brand-primary;
        cursor: pointer;
      }
    }
  }
  .form-group {
    display: block !important;
    margin-bottom: 0px;
    label {
      display: block !important;
      padding: 0px;
      text-align: left;
      max-width: 100%;
    }
  }
  .progress {
    margin: 2rem 0px 0px;
  }
}
</style>
