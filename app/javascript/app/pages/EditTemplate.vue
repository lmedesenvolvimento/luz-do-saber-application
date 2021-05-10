<template>
  <div id="new-template-page">
    <div class="container-fluid">
      <h1 v-if="errorMessage">{{ errorMessage }}</h1>
      <div v-if="question.template" class="panel panel-primary panel--box-shadow">
        <div class="panel-heading">
          <h3 class="title">
            {{ question.template.name }}
            <small v-if="unit" class="subtitle pull-right">
              Unidade: {{ unit.title }}
            </small>
          </h3>
        </div>
        <div class="panel-body">
          <div v-if="template" class="container-fluid">
            <ls-template-title :template="question.template" />
            
            <ls-template-description 
              v-model="description" 
              :template="question.template"
            />

            <ls-template-order v-model="order" />
            
            <router-view
              @updateItems="updateItems"
              @validateItems="validateItems"
              @defaultActionsVisibilty="defaultActionsVisibilty"
              @submitTemplate="submitTemplate"
              :template="question.template.slug"
              :fetch-parent-items="this.fetchItems"
              :is-editing="true"
            />
          </div>
        </div>
        <div class="panel-footer">
          <div class="container-fluid">
            <div v-if="isActionsVisible" class="panel-footer-actions">
              <a :href="backUrl" class="btn btn-default">
                Cancelar
              </a>
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
import { 
  clone, 
  differenceBy, 
  omit,
  filter, 
  uniqBy 
} from 'lodash'

import { trustObject } from '../utils/utils'

import NewTemplate from './NewTemplate'
import { WordTypes } from '../types'
import Item from '../models/Item'

function mapAlternative(alternative, array){
  const { id, word_id } = alternative
  const word_type = WordTypes[alternative.word_type].value

  const value_items_attributes = filter(array, { key_id: id }).map((a) => {
    const word_type = WordTypes[a.word_type].value    
    return new Item(a.type, word_type, a.word_text, a.remote_image_url)
  })

  const item = new Item(
    alternative.type, 
    word_type, 
    alternative.word_text,
    alternative.remote_image_url,
    uniqBy(value_items_attributes, 'word_text')
  )

  item.id = id
  item.word_id = word_id

  return item
}

function mapQuestion(question) {
  const newQuestion = Object.assign({}, question)

  newQuestion.template = {
    question_description: question.description.text,
    ...question.template
  }

  newQuestion.items = question.items.map(alternative => {
    if (alternative.key_id) {
      return null
    }
    return mapAlternative(alternative, question.items)
  }).filter(a => a)

  newQuestion.items = uniqBy(newQuestion.items, 'word_text')
  newQuestion.raw_items = question.items

  return newQuestion
}

const unpermitted_params = ['key_id', 'word_id']

export default {
  extends: NewTemplate,
  data() {
    return {
      errorMessage: '',
      question: {},
      edit: true
    }
  },
  computed: {
    template() {
      return this.question.template
    },
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    }
  },
  methods: {
    fetchItems(){
      return this.items
    },
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
        const { id } = this.$route.params
        let items_attributes = []

        if (this.isActionsVisible) {
          const items = this.items.map(this.mapItems)
  
          const keys = this.question.raw_items.filter(({key_id}) => key_id)
          const values = this.question.raw_items.filter(({key_id}) => !key_id)
          
          let new_attributes = differenceBy(items, values, 'word_text') // novos items em valores
          let remove_attributes = differenceBy(values, items, 'word_text') // removendo itens em valores
  
          let value_items_attributes = []
  
          items.map((i) => {
            if (i.value_items_attributes) {
              if (i.type === 'key' && i.value_items_attributes.length){
              i.value_items_attributes = i.value_items_attributes.map((item) => {
                if (i.id) {
                  return { key_id: i.id, ...item }
                }
                return item
              })
              if (i.id) {            
                value_items_attributes = value_items_attributes.concat(i.value_items_attributes) // concatenando todos valores que pertence há chave
              }
              }
            }            
          })
  
          remove_attributes = remove_attributes.concat(
            differenceBy(keys, value_items_attributes, 'word_text')
          )
  
          new_attributes = new_attributes.concat(
            differenceBy(value_items_attributes, keys, 'word_text')
          )
  
          remove_attributes.forEach(item => {
            item._destroy = '1'
            delete item.text
          })
          
  
          items_attributes = [...new_attributes, ...remove_attributes].map((i) => {
            if (i.type === 'key') {
              if (i.value_items_attributes) {
                i.value_items_attributes = i.value_items_attributes.map((v) => omit(v, unpermitted_params))
              }
              return omit(i, unpermitted_params)
            }
            return omit(i, unpermitted_params.slice(1))
          })
        }

        const payload = {
          question_question: {
            order: this.order,
            question_question_template_id: this.question.template.id,
            description_text: this.description.text
          }
        }

        if (this.isActionsVisible) {
          payload.question_question.items_attributes = items_attributes
        }

        this.busy = true

        const { data } = await this.$axios.put(`/question/questions/${id}.json`, payload)

        if (!data.success) {
          throw new Error('Error desconhecido!')
        }

        this.$notify({
          group: 'success',
          title: 'Sucesso',
          text: 'Questão atualizada com sucesso!'
        })
        
        window.location.assign(`/question/questions/${id}`)
      } catch (error) {
        if(error.request) {
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
    }
  },
  async created() {
    try {
      const { id } = this.$route.params
      const { data } = await this.$axios.get(`/question/questions/${id}/edit.json`)

      this.question = mapQuestion(data)
      
      this.order = this.question.order
      this.description = this.question.description

      this.$set(this, 'items', trustObject(this.question.items))
      
      // forçando redirecionamento para template filho
      if (this.$route.path !== `/edit-template/${id}/${this.template.slug}`){
        this.$router.replace({ path: `/edit-template/${id}/${this.template.slug}`})
      }
    } catch(e) {
      this.errorMessage = e.toString()
    }
  }
}
</script>

<style>

</style>