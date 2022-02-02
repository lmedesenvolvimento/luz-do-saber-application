<template>
  <div id="monte-frase-arrastar">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word
          ref="embedded"
          :embedded="true"
          :text="initialCorrect"
          :word-type="word_type"
          :word-type-disabled="true"
          :audio-required="false"
          :image-required="false"
          :audio-visible="false"
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
      initialCorrect: []
    }
  },
  created() {
    if (this.isEditing) {
      this.initialCorrect = this.theKey.text
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
        const text = word.text
        let newText = ''

        newText = text

        this.items = [new Item('key', WordTypes.input_custom.value, newText)]

        if (this.isEditing) {
          const newValues = newText.split(' ')
          const value_items_attributes = newValues.map(el => {
            return new Item('value', WordTypes.input_custom.value, el)
          })

          this.items = [
            new Item(
              'key',
              WordTypes.input_custom.value,
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
#monte-frase-arrastar {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }
}
</style>
