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

import CreateWordModal from '../../modals/CreateWordModal'

export default {
  mixins: [TemplateMixin],
  data(){
    return {
      busy: false,
      word_type: WordTypes.frase.value,
      items: [],
      initialCorrect: []
    }
  },
  created() {
    // if(this.items.length > 0) {     
    //  this.items.map((el, index) => {
    //    if (el.type === "key") {
    //      this.initialCorrect.push(el.text)
    //    }
    //   })
    // }
  },
  computed: {
    isSubmitDisabled() {
      return !this.$parent.hasDescription
    }
  },
  methods: { 
    async submit(){
      try {
        this.busy = true        
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit()
        const word = data
        const text = word.text
        let newText = ""

        newText = text
               

        this.items.push(
          new Item('key', WordTypes.input_custom.value, newText)
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
#monte-frase-arrastar{
  .actions{
    .btn:first-child {
      margin-right: 5px;
    }
  }
}
</style>