<template>
  <div id="ortografia">
    <div class="create-word">
      <div class="row">
        <div class="col-md-7">
          <ls-modal-create-word 
            ref="embedded"
            :embedded="true" 
            word-type-label="Palavra:"
            :text="initialCorrect"
            :word-type="WordTypes.input_custom.value"
            :word-type-visible="false"
            :word-type-visible="false"
            :audio-required="false"
            :audio-visible="false"
            :image-visible="false"
            :image-required="false"
          >
            <template v-slot:word="scope">
              <label>
                Palavra:
              </label>            
              <span class="input">              
                <input 
                  v-model="scope.word.text"
                  class="form-control" 
                />
              </span>
            </template>
          </ls-modal-create-word>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="alternatives">
      <div class="row">
        <div class="col-md-7">
          <div class="items-input-group select-multiple incorrect-items-input-group">
            <div class="label">Alternativas </br> Incorretas:</div>
            <v-select
              v-model="incorrects"
              @input="addItemIncorrect"
              :searchable="isSearchable"
              multiple
              taggable
              label="word_text"
            >
              <span slot="no-options">{{ searchFeedback }}</span>
            </v-select>
          </div>
         
        </div>
        <div class="col-md-5"></div>
      </div>
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
import { WordTypes } from '../../types'
import TemplateMixin from '../../mixins/TemplateMixin'
import Item from '../../models/Item'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.substantivo_comum,
      busy: false,
      incorrects: [],
      incorrectsItem: [],
      initialCorrect: []
    }
  },
  created() {
    if(this.isEditing) {    
      this.initialCorrect = this.theKey.text
      this.incorrects = this.generateInputValues.map(el=>{ return el.text })
      this.addItemIncorrect(this.incorrects)
    }
  },
  computed: {
    invalid() {
      return this.maxItems.length >= this.items.length 
    },
    searchFeedback() {
      return this.isSearchable
        ? "Digite uma alternativa para continuar..."
        : "Limite máximo de frases foi atigindo.";
    },
    isSearchable() {
      return this.incorrects.length  < 3;
    },
    backUrl() {
      const { id } = this.$route.params
      return `/question/questions/${id}`
    },
  },
  methods: {
    async submit(){ 
      try {
        this.busy = true
        const items = []
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()

        if(this.isEditing) {
          const value_items_attributes = [new Item('value', WordTypes.input_custom.value, data.text)]
          this.items = []
          this.items.push(
            new Item('key', WordTypes.input_custom.value, data.text, null, value_items_attributes)
          )
          this.items = [
          ...this.items.filter(({ type }) => type === 'key'),
          ...this.incorrectsItem
          ]
        } else {
          this.items.push(
            new Item('key', WordTypes.input_custom.value, data.text)
          )
        }       

        // Salvando no banco novo template de questão
        setTimeout(() => {
         this.$emit('submitTemplate')
        }, 1200)
      } 
      catch(e) {
        this.$notify({
          group: 'danger',
          title: 'Falha',
          text: e.message
        })

        this.busy = false
      } finally {
        this.busy = false
      }
    },
    addItemIncorrect(alternatives){
      // Example for mapping incorrect inputs
      const incorrects = alternatives.map((text) => {
        return new Item("value", this.WordTypes.input_custom.value, text);
      });

      this.incorrectsItem = incorrects
      this.items = [
        ...this.items.filter(({ type }) => type === 'key'),
        ...incorrects
      ]
    },
    validateItems() {
      this.$emit('validateItems', !(this.maxItems.length <= this.items.length))
    }
  },
  mounted() {
    this.$emit('defaultActionsVisibilty', false)
  }
}
</script>

<style lang="scss">
#ortografia {
  .create-word{
    margin-top: $gap * 2;
  }
  .alternatives {
    @include template-editor-field;
    .label {
      align-self: flex-start;
    }
  }
  .actions{
    .btn:first-child {
      margin-right: 5px;
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