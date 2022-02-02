<template>
  <div id="ditado-frase">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word
          ref="embedded"
          :embedded="true"
          :text="initialCorrect"
          :is-editing="isEditing"
          :word-id="word_id"
          :word-type="word_type"
          :word-type-disabled="true"
          :audio-required="true"
          :image-required="false"
          :audio-visible="true"
          :image-visible="false"
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
      word_type: WordTypes.frase.value,
      items: [],
      initialCorrect: [],
      word_id: null
    }
  },
  created() {
    if (this.isEditing) {
      this.initialCorrect = this.theKey.text
      this.word_id = this.theKey.word_id
    }
  },
  computed: {
    isSubmitDisabled() {
      return !this.$parent.hasDescription
    },
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    }
  },
  methods: {
    async submit() {
      try {
        this.busy = true
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        const word = data
        const text = word.text ? word.text : this.initialCorrect

        let newText = ''

        newText = text

        this.items = [new Item('key', WordTypes.frase.value, newText)]

        if (this.isEditing) {
          const newValues = newText.split(' ')
          const value_items_attributes = newValues.map(el => {
            return new Item('value', WordTypes.frase.value, el)
          })

          this.items = [
            new Item(
              'key',
              WordTypes.frase.value,
              newText,
              null,
              value_items_attributes
            )
          ]
        }
        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 1500)
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
#ditado-frase {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }
}
</style>
