<template>
  <div id="new-template-page">
    <div class="container-fluid">
      <div class="panel panel-primary panel--box-shadow">
        <div class="panel-heading">
          <h3 class="title">
            {{ template.name }}
            <small v-if="unit" class="subtitle pull-right">
              Unidade: {{ unit.title }}
            </small>
          </h3>
        </div>
        <div class="panel-body">
          <div v-if="template" class="container-fluid">
            <ls-template-title :template="template" />

            <ls-template-description
              v-model="description"
              :template="template"
            />

            <ls-template-order v-model="order" />

            <router-view
              @updateItems="updateItems"
              @validateItems="validateItems"
              @updateSubtitle="updateSubtitle"
              @defaultActionsVisibilty="defaultActionsVisibilty"
              @submitTemplate="submitTemplate"
              :template="template.slug"
            />
          </div>
        </div>
        <div class="panel-footer">
          <div class="container-fluid">
            <div v-if="isActionsVisible" class="panel-footer-actions">
              <router-link
                tag="button"
                class="btn btn-default"
                :to="{ name: 'templates' }"
                >Cancelar</router-link
              >
              <button
                class="btn btn-primary"
                :disabled="busy || isSubmitDisabled"
                @click.stop="submitTemplate"
              >
                Criar Atividade
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import objectToFormData from 'object-to-formdata'
import { omit, uniqBy } from 'lodash'

const unpermitted_params = ['text']

export default {
  data() {
    return {
      items: [],
      description: {},
      order: null,
      subtitle: null,
      unit: null,
      busy: false,
      isValidItems: false,
      isActionsVisible: true,
      edit: false
    }
  },
  computed: {
    template() {
      const { id } = this.$route.params
      return this.$store.getters['templates/getTemplate'](id) || {}
    },
    allowSameWords() {
      const templatesWithSameWords = [
        'alternativa-imagens-com-subtitulo',
        'sequencia-numerica',
        'sequencia-numerica-2'
      ]
      return templatesWithSameWords.includes(this.template.slug)
    },
    hasDescription() {
      return this.description && this.description.id
    },
    isSubmitDisabled() {
      if (!this.hasDescription) {
        return true
      }
      if (!this.isValidItems) {
        return true
      }
      if (!this.order) {
        return true
      }
      return false
    }
  },
  methods: {
    async submitTemplate() {
      if (!this.description.id) {
        this.description.$error = true
        this.$notify({
          group: 'danger',
          title: 'Falha na Validação',
          text: 'Descrição é obrigatório'
        })
        return
      }

      if (!this.order) {
        this.$notify({
          group: 'danger',
          title: 'Falha na Validação',
          text: 'Ordem é obrigatório'
        })
        return
      }

      if (!this.isValidItems) {
        this.$notify({
          group: 'danger',
          title: 'Falha na Validação',
          text: 'Itens são obrigatório'
        })
        return
      }
      try {
        const { id, unit_id } = this.$route.params
        const { group_id } = this.$route.query

        const items_attributes = this.allowSameWords
          ? this.items.map(this.mapItems)
          : uniqBy(this.items.map(this.mapItems), 'word_text')

        let subtitle = !!this.subtitle ? this.subtitle.text : ''
        const payload = {
          question_question: {
            order: this.order,
            question_question_template_id: id,
            subtitle,
            unit_id,
            description_text: this.description.text,
            items_attributes
          }
        }

        if (this.$role === 'professor') {
          payload.question_question.group_id = group_id
        }

        this.busy = true

        const { data } = await this.$axios.post(
          '/question/questions.json',
          payload
        )

        if (!data.success) {
          throw new Error('Error desconhecido!')
        }

        this.$notify({
          group: 'success',
          title: 'Sucesso',
          text: 'Questão criada com sucesso!'
        })

        // redirect to template url
        window.location.assign(data.url)
      } catch (error) {
        if (error.request) {
          const { errors } = JSON.parse(error.request.response)
          for (const error of errors) {
            this.$notify({
              group: 'danger',
              title: 'Error',
              text: error
            })
          }
        }
      } finally {
        this.busy = false
      }
    },
    defaultActionsVisibilty(visible) {
      this.isActionsVisible = visible
    },
    updateItems(items) {
      this.items = items
    },
    updateSubtitle(subtitle) {
      this.subtitle = subtitle
    },
    validateItems(isValidItems) {
      this.isValidItems = isValidItems
    },
    mapItems(item) {
      const { value_items_attributes } = item
      if (value_items_attributes && value_items_attributes.length) {
        item.value_items_attributes = value_items_attributes.map(this.mapItems)
      }
      return omit(item, unpermitted_params)
    }
  },
  async mounted() {
    if (this.edit) {
      return
    }
    const { id, theme_id, unit_id } = this.$route.params
    const { group_id } = this.$route.query

    if (this.$role === 'professor' && !group_id) {
      this.$router.replace('/')
    }

    const { data } = await this.$axios(
      `/themes/${theme_id}/units/${unit_id}.json`
    )

    this.unit = data
    this.order = data.total_questions + 2
  }
}
</script>

<style lang="scss" scoped>
#new-template-page {
  padding: ($gap * 6) 0px;
  .panel {
    border-radius: 5px;
    &-heading {
      text-align: left;
      .title {
        margin: 8px 36px;
        .subtitle {
          line-height: 24px;
          color: #eee;
        }
      }
    }
    &-footer {
      background-color: white;
      border-top: none;
      &-actions {
        .btn:not(:last-child) {
          margin-right: $gap;
        }
      }
    }
    &::after {
      display: block;
      content: ' ';
      background-color: $brand-primary;
      height: ($gap * 5);
      border-radius: 0px 0px 5px 5px;
    }
  }
}
</style>
