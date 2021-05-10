<template>
  <div id="questionario-item-imagem">
    <div class="row">  
      <div class="col-md-7 first">
        <b>Selecione a imagem Correta:</b>
        <br></br>      
        <ls-modal-create-word 
          ref="correct"
          :embedded="true"
          :label="'Imagem Correta:'"
          :is-not-empty="isNotEmpty"
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
        <br></br>        
        <ls-modal-create-word 
          ref="wrong1"
          :embedded="true"
          :label="'Imagens Erradas:'"
          :is-not-empty="isNotEmpty"
          :word-type="word_type"
          :text-visible="false"
          :text-required="false"
          :audio-visible="false"
        /> 
        <ls-modal-create-word 
          ref="wrong2"
          :embedded="true"
          :word-type="word_type"
          :is-not-empty="isNotEmpty"
          :text-visible="false"
          :text-required="false"
          :audio-visible="false"
        />  
        <ls-modal-create-word 
          ref="wrong3"
          :embedded="true"
          :is-not-empty="isNotEmpty"
          :word-type="word_type"
          :text-visible="false"
          :text-required="false"
          :audio-visible="false"
        />         
      </div>
      <div class="col-md-5"></div>
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
        :disabled="busy || isSubmitDisabled"
      >
        Criar Atividade
      </button>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { clone } from 'lodash'
import TemplateMixin from '../../mixins/TemplateMixin'

import Item from '../../models/Item'
import Word from '../../models/Word'

import { WordTypes } from '../../types'

import CreateImageModal from '../../modals/CreateImageModal'

export default {
  mixins: [TemplateMixin],
  data(){
    return {
      busy: false,
      word_type: WordTypes.input_custom.value,
      items: [], 
      validate: true,
      isNotEmpty: false
    }
  },
  created() {
    if (this.items.length > 0 ) {
      this.isNotEmpty = true
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
    }
  },
   watch: {
    items: {
      handler() {
        if (this.items.length >= 4) {
          this.$emit("submitTemplate");
        }
      },
    },
  },
  methods: {
    async submit(){
      try {
        this.items = []
        this.busy = true       
       
        this.submitWord(this.$refs.correct, 'correct')
        this.submitWord(this.$refs.wrong1, 'wrong')
        this.submitWord(this.$refs.wrong2, 'wrong')
        this.submitWord(this.$refs.wrong3, 'wrong')

        // Salvando no banco novo template de questão
        // setTimeout(() => {
        //    //this.$emit('submitTemplate')
        // }, 10000)
      } 
      catch(e) {
        this.busy = false
      }
    }, 
    async submitWord(ref, type){
      try {
        this.busy = true        
        // Aguardando nova palavra ser criada
        const { data } = await ref.submit()
        const word = data

        if (type === 'correct') {
          const value_items_attributes = [
            new Item('value', this.WordTypes.input_custom.value,  word.text) 
          ]

          this.items.push(
            new Item('key', WordTypes.input_custom.value, word.text, null, value_items_attributes)
          )
        } else {
          this.items.push(
            new Item('value', WordTypes.input_custom.value, word.text)
          )
        } 
      } 
      catch(e) {
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
#questionario-item-imagem{
  .actions{
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

  .form-group{
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