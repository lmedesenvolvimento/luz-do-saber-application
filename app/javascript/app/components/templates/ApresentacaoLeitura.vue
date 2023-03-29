<template>
  <div id="apresentacao-leitura">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word
          ref="embedded"
          :embedded="true"
          word-type-label="Texto:"
          :word-type="word_type"
          :word-type-visible="false"
          :audio-required="true"
          :image-required="true"
          :word-id="word_id"
          :is-editing="isEditing"
          :text="palavra"
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
      palavra: '',
      remoteImgUrl: null
    }
  },
  computed: {
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    },
    word_id() {
      if (this.theKey) {
        return this.theKey.word_id
      }
      return null
    },
    getNameImage() {
      if (this.remoteImgUrl) {
        const url = this.remoteImgUrl
          .split('/')
          .pop()
          .split('?')
          .shift()
        if (url) return url
        else return ''
      } else return ''
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
  created() {
    if (this.isEditing) {
      this.palavra = this.theKey.text
    }
  },
  methods: {
    async submit() {
      try {
        this.busy = true
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        const items = []

        // const value_items_attributes = [
        //   new Item("value", WordTypes.input_custom.value, data.text),
        // ];

        const word = data.text ? data.text : this.palavra

        items.push(
          new Item('key', WordTypes.input_custom.value, word, this.remoteImgUrl)
        )

        Vue.set(this, 'items', items)

        // Salvando no banco novo template de questão

        if (this.isEditing) {
          setTimeout(() => {
            this.$emit('submitTemplate')
          }, 3000)
        }
      } catch (e) {
        this.$notify({
          group: 'danger',
          title: 'Falha',
          text: e.message
        })
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
#apresentacao-leitura {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }
}
</style>
