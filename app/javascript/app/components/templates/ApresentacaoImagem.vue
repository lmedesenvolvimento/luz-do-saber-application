<template>
  <div id="apresentacao-imagem">
    <div class="row">
      <div class="col-md-7 first">
        <ls-modal-create-word
          ref="correct"
          :embedded="true"
          :word-type="word_type"
          :is-editing="isEditing"
          :word-id="word_id"
          :word-type-visible="false"
          :text-visible="false"
          :text-required="false"
          :label="'Imagem:'"
          :audio-visible="true"
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
      items: [],
      validate: true
    }
  },
  created() {},
  computed: {
    searchFeedback() {
      return this.isSearchable
        ? 'Digite uma frase para continuar...'
        : 'Limite máximo de frases foi atigindo.'
    },
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    },
    isSubmitDisabled() {
      return !this.$parent.hasDescription
    },
    word_id() {
      if (this.theKey) {
        return this.theKey.word_id
      }
      return null
    }
  },
  watch: {
    items: {
      handler() {
        if (this.items.length >= 1 && !this.isEditing) {
          this.$emit('submitTemplate')
        }
      }
    }
  },
  methods: {
    async submit() {
      try {
        this.busy = true

        const { data } = await this.$refs.correct.submit()

        if (this.isEditing && data.success) {
          this.$emit('submitTemplate')
          return true
        }

        const word = data

        if (data.images[0]) this.remoteImgUrl = data.images[0].url

        const value_items_attributes = [
          new Item('value', this.WordTypes.input_custom.value, word.text)
        ]

        const items = [
          new Item(
            'key',
            WordTypes.input_custom.value,
            word.text,
            this.remoteImgUrl,
            value_items_attributes
          )
        ]

        Vue.set(this, 'items', items)

        if (this.isEditing) {
          setTimeout(() => {
            this.$emit('submitTemplate')
          }, 2500)
        }
      } catch (e) {
        this.busy = false
      }
    }
  },
  mounted() {
    this.$emit('defaultActionsVisibilty', false)
  }
}
</script>

<style lang="scss">
#apresentacao-imagem {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .first {
    padding: 16px 16px 25px 16px;
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
