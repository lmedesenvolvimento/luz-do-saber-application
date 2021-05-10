<template>
  <div id="letra-maiuscula">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word 
          ref="embedded"
          :embedded="true" 
          :word-type="word_type" 
          :word-type-disabled="true"
          :audio-required="false"
          :audio-visible="false"
          :image-required="false"
          :word-id="word_id"
          :is-editing="isEditing"
        />        
      </div>
      <div class="col-md-5"></div>
    </div>
     <div class="letras">
    <div class="row">
        <div class="col-md-7">
          <div class="letras-input-group">
            <label class="label is-top">Letras</label>
            <span class="input">
              <ls-select-letters :max-items="26" @change="onInput" :initial-letras="initialLetras" />
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
    </div>
  </div>
    <div v-if="isEditing" class="actions">
      <a
        tag="button"
        class="btn btn-default"
        :href="backUrl"
        :disabled="busy"
        >Cancelar
      </a>
      <button
        @click="submit"
        class="btn btn-primary"
        :disabled="busy || !hasDescription"
      >
        Criar Atividade
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
import { clone } from 'lodash'
import TemplateMixin from '../../mixins/TemplateMixin'

import Item from '../../models/Item'
import Word from '../../models/Word'

import { WordTypes } from '../../types'

import CreateWordModal from '../../modals/CreateWordModal'

export default {
  mixins: [TemplateMixin],
  data(){
    return {
      busy: true,
      word_type: WordTypes.frase.value,
      items: [],
      letras: [],
      initialLetras: [],
      initialPalavra: []
    }
  },
   created() {
    
     if(this.items.length > 0) {
      this.initialPalavra = this.items[0].text
     this.initialItems = this.items[0].value_items_attributes.map((el) => {       
      this.initialLetras.push(el.text)
       
      })
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
    }
  },
  methods: { 
    onInput({data, invalid}) {
      const alternatives = data
      const cloneItems = []

      this.invalid = invalid
      
      alternatives.map(({ text }) => {
        if (!text){
          return
        }
        cloneItems.push(
          new Item('value', this.WordTypes.letra.value, text)
        )
      })
      Vue.set(this, 'letras', cloneItems)
      if(this.letras.length >= 1){
        this.busy = false
      } else {
        this.busy = true
      }

    },
    async submit(){
      try {
        this.busy = true        
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        
        this.items.push(
          new Item('key', WordTypes.input_custom.value, data.text, data.images[0]?.url, this.letras)
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
      }
    }
  },
  mounted() {
    this.$emit('defaultActionsVisibilty', false)
  }
}
</script>

<style lang="scss">
#letra-maiuscula{
  .actions{
    .btn:first-child {
      margin-right: 5px;
    }
  }
   .letras {
    @include template-editor-field;
  }
}
</style>
