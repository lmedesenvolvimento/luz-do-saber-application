<template>
  <div id="questionario-item-imagem">
    <div class="row">
      <div class="col-md-7 first">
        <b>Selecione a imagem Correta:</b>
        <br />
        <ls-modal-create-word
          ref="correct"
          :embedded="true"
          :label="'Imagem Correta:'"
          :image-url="getNameImage(remoteImgUrl)"
          :word-type="word_type"
          :text-visible="false"
          :text-required="false"
          :audio-visible="false"
        />
      </div>
      <div class="col-md-5"></div>
    </div>
    <div class="row">
      <div class="col-md-7">
        <b>Selecione as imagens Erradas:</b>
        <br />
        <ls-modal-create-word
          ref="wrong1"
          :embedded="true"
          :label="'Imagens Erradas:'"
          :image-url="getNameImage(e_remoteImgUrl1)"
          :word-type="word_type"
          :text-visible="false"
          :text-required="false"
          :audio-visible="false"
        />
        <ls-modal-create-word
          ref="wrong2"
          :embedded="true"
          :word-type="word_type"
          :image-url="getNameImage(e_remoteImgUrl2)"
          :text-visible="false"
          :text-required="false"
          :audio-visible="false"
        />
        <ls-modal-create-word
          ref="wrong3"
          :embedded="true"
          :image-url="getNameImage(e_remoteImgUrl3)"
          :word-type="word_type"
          :text-visible="false"
          :text-required="false"
          :audio-visible="false"
        />
      </div>
      <div class="col-md-5"></div>
    </div>
    <div v-if="isEditing" class="actions">
      <a tag="button" class="btn btn-default" :href="backUrl" :disabled="busy"
        >Cancelar
      </a>
      <button
        @click="submit"
        class="btn btn-primary"
        :disabled="busy || !hasDescription"
      >
        Editar Atividade
      </button>
    </div>
    <div v-else class="actions">
      <router-link
        tag="button"
        class="btn btn-default"
        :to="{ name: 'templates' }"
        :disabled="busy"
        >Cancelar</router-link
      >
      <button
        @click="submit"
        class="btn btn-primary"
        :disabled="busy || !hasDescription"
      >
        Criar Atividade
      </button>
    </div>
  </div>
</template>

<script>
import TemplateMixin from '../../mixins/TemplateMixin'
import Item from '../../models/Item'
import { WordTypes } from '../../types'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      busy: false,
      word_type: WordTypes.input_custom.value,
      items: [],
      validate: true,
      remoteImgUrl: null,
      e_remoteImgUrl1: null,
      e_remoteImgUrl2: null,
      e_remoteImgUrl3: null
    }
  },
  created() {
    if (this.isEditing) {
      this.remoteImgUrl = this.theKey.remote_image_url
      if (this.generateInputValues[0])
        this.e_remoteImgUrl1 = this.generateInputValues[0].remote_image_url
      if (this.generateInputValues[1])
        this.e_remoteImgUrl2 = this.generateInputValues[1].remote_image_url
      if (this.generateInputValues[2])
        this.e_remoteImgUrl3 = this.generateInputValues[2].remote_image_url
    }
  },
  computed: {
    searchFeedback() {
      return this.isSearchable
        ? 'Digite uma frase para continuar...'
        : 'Limite máximo de frases foi atigindo.'
    },
    isSubmitDisabled() {
      return !this.$parent.hasDescription
    },
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    }
  },
  watch: {
    items: {
      handler() {
        if (this.items.length >= 4 && !this.isEditing) {
          this.$emit('submitTemplate')
        }
      }
    }
  },
  methods: {
    async submit() {
      try {
        this.items = []
        this.busy = true

        await this.submitWord(this.$refs.correct, 'correct', this.remoteImgUrl)
        await this.submitWord(this.$refs.wrong1, 'wrong', this.e_remoteImgUrl1)
        await this.submitWord(this.$refs.wrong2, 'wrong', this.e_remoteImgUrl2)
        await this.submitWord(this.$refs.wrong3, 'wrong', this.e_remoteImgUrl3)

        if (this.isEditing) {
          setTimeout(() => {
            this.$emit('submitTemplate')
          }, 10000)
        }
      } catch (e) {
        this.busy = false
      }
    },
    async submitWord(ref, type, remote_img_url) {
      try {
        this.busy = true
        // Aguardando nova palavra ser criada
        const { data } = await ref.submit()
        const word = data

        if (data.images[0]) remote_img_url = data.images[0].url

        if (type === 'correct') {
          const value_items_attributes = [
            new Item(
              'value',
              this.WordTypes.input_custom.value,
              word.text,
              remote_img_url
            )
          ]

          this.items.push(
            new Item(
              'key',
              WordTypes.input_custom.value,
              word.text,
              remote_img_url,
              value_items_attributes
            )
          )
        } else {
          this.items.push(
            new Item(
              'value',
              WordTypes.input_custom.value,
              word.text,
              remote_img_url
            )
          )
        }
        if (this.items.length >= 4 && this.isEditing)
          this.$emit('submitTemplate')
      } catch (e) {
        this.busy = false
      }
    },
    getNameImage(img) {
      const remote = img
      if (remote) {
        const url = remote
          .split('/')
          .pop()
          .split('?')
          .shift()
        if (url) return url
        else return ''
      } else return ''
    }
  },
  mounted() {
    this.$emit('defaultActionsVisibilty', false)
  }
}
</script>

<style lang="scss">
#questionario-item-imagem {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .first {
    padding: 16px 16px 35px 16px;
  }

  .actions {
    padding-top: 30px;
  }

  .form-group {
    display: flex;
    align-items: center;
    padding: 2px 0px;
    margin-bottom: 0px;
    label {
      flex: 1;
    }
    .form-control {
      text-indent: 12px;
      padding: 0px;
      flex: 3;
    }
  }

  .correct-items,
  .incorrect-items {
    @include template-editor-field;
    margin: $gap 0px;
    &-input-group {
      .v-select {
        flex: 3;
      }
    }
  }
}
</style>
