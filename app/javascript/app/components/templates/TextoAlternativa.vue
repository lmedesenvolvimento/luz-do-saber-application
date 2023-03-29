<template>
  <div id="ditado-frase">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div
            class="items-input-group select-multiple incorrect-items-input-group"
          >
            <div class="label">
              Alternativa Certa:
            </div>
            <v-select
              v-model="correct"
              @input="addItemCorrect"
              taggable
              label="word_text"
            >
              <span slot="no-options">
                Digite uma alternativa para continuar...
              </span>
            </v-select>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    </br>
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div
            class="items-input-group select-multiple incorrect-items-input-group"
          >
            <div class="label">
              Alternativas Erradas:
            </div>
            <v-select
              v-model="sentences"
              @input="addItem"
              :searchable="isSearchable"
              multiple
              taggable
              label="word_text"
            >
              <span slot="no-options">
                {{ searchFeedback }}
              </span>
            </v-select>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div> 
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word 
          ref="embedded"
          :embedded="true"
          :text="initialPalavra"
          :word-type="word_type" 
          :word-type-visible="false"
          :audio-required="false"
          :image-required="false"
          :audio-visible="false"
          :image-visible="false"
          :wordTypeVisible="false"
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
        :disabled="isSubmitDisabled"
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
        :disabled="isSubmitDisabled"
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
  data(){
    return {
      busy: false,
      word_type: WordTypes.input_custom.value,
      items: [],
      sentences: [],
      correct: [],
      alternativeCorrect: [],
      alternativeIncorrect: [],
      clonedItem: [], 
      validate: true,
      initialErrada: [],
      initialPalavra: ''
    }
  },
  created() {
    if(this.isEditing) {        
      this.initialPalavra = this.theKey.text
      this.correct = this.theKey.value_items_attributes[0].text
      this.addItemCorrect(this.theKey.value_items_attributes[0].text)
      this.generateInputValues.map(el=> {
        this.initialErrada.push(el.text)
      })
      this.sentences = this.initialErrada
      this.addItem(this.initialErrada)
     
    }
  },
  computed: {
    searchFeedback() {
      return this.isSearchable
        ? 'Digite uma alternativa para continuar...'
        : 'Limite máximo de frases foi atigindo.'
    },
    isSearchable() {
      return this.sentences.length < this.maxItems
    },
    isSubmitDisabled() {
      return this.busy || !this.$parent.hasDescription || 
        !this.correct.length > 0  || this.sentences.length < 3
    },     
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    }  
  },
  methods: { 
     addItem(alternatives) {
      const incorrects = alternatives.map((text) => {
        return new Item('value', this.WordTypes.input_custom.key, text)
      })
      this.alternativeIncorrect = incorrects
      this.clonedItem = this.items = [
        ...this.items.filter(({ type }) => type === 'key'),
        ...incorrects
      ]
    },
    addItemCorrect(alternatives) {
      this.alternativeCorrect = new Item('value', this.WordTypes.input_custom.key, alternatives)
    },
    async submit(){
      try {
        this.busy = true        
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        const word = data
        const items = []

        const value_items_attributes = [this.alternativeCorrect]

        items.push(
          new Item('key', WordTypes.input_custom.value, word.text, null, value_items_attributes)
        )

        const newItem = items.concat(this.alternativeIncorrect)

        Vue.set(this, 'items', newItem)

        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 600)
      } 
      catch(e) {
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
#ditado-frase{
  .actions{
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .form-group{
  display: flex;
  align-items: center;
  padding: ($gap * 2) 0px;
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