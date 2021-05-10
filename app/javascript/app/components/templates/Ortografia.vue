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
            :word-type-disabled="true"
            :word-type-visible="false"
            :audio-required="false"
            :audio-visible="false"
            :image-visible="false"
            :image-required="false"
          >
            <template v-slot:word="scope">
              <label>
                Palavra
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
          <!-- <ls-select-multiple
            class="alternatives-input-group"
            :options="words"
            :max-items="maxItems"
            label="Alternativas <br> Incorretas"
            :label-html="true"
            @search="onSearch"
            @input="inputIncorrectItem"
          /> -->
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="actions">
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
        :disabled="busy  || invalid || !hasDescription"
      >
        Criar Atividade
      </button>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { clone, values } from 'lodash'
import { WordTypes } from '../../types'
import Templates from '../../components/templates/templates.json'
import TemplateMixin from '../../mixins/TemplateMixin'

import Item from '../../models/Item'

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.substantivo_comum,
      busy: false,
      incorrects: [],
      initialCorrect: [],
      initialIncorrect: []
    }
  },
  created() {
    if(this.items.length > 0) {     
     this.items.map((el, index) => {
       if (el.type === "key") {
         this.initialCorrect.push(el.text)
       } else {
         this.initialIncorrect.push(el.text)
         this.incorrects = this.initialIncorrect
       }
      })
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
  },
  methods: {
    async submit(){ 
      try {
        this.busy = true
        const items = []
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()

        this.items.push(
          new Item('key', WordTypes.substantivo_comum.value, data.text)
        )
        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 400)
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
        return new Item("value", this.WordTypes.input_custom.key, text);
      });
      // union keys with incorrect items
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