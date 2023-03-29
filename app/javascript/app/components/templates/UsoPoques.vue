<template>
  <div id="uso-porques">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word
          ref="embedded"
          :embedded="true"
          :text="initialText"
          :word-type="word_type"
          :word-type-visible="false"
          :audio-required="false"
          :image-required="false"
          :audio-visible="false"
          :image-visible="false"
        />
      </div>
      <div class="col-md-5"></div>
    </div>
    <div class="row">
      <div class="col-md-7">
        <div
          class="items-input-group select-multiple incorrect-items-input-group"
        >
          <div class="label">Correto:</div>
          <v-select
            :value="selectedPorque"
            :options="porques"
            placeholder="Selecionar"
            label="text"
            @input="updatePorque"
          ></v-select>
        </div>
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
        :disabled="busy || !hasDescription || !selectedPorque"
      >
        Criar Atividade
      </button>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { difference } from 'lodash'
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
      porques: ['PORQUE', 'POR QUE', 'PORQUÊ', 'POR QUÊ'],
      selectedPorque: null,
      initialText: null,
      initialPorque: null
    }
  },
  created() {
    if (this.isEditing) {
      this.initialText = this.theKey.text
      this.initialPorque = this.theKey.value_items_attributes[0]?.text
      this.selectedPorque = this.initialPorque
    }
  },
  computed: {
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

        //adicioando porques errados
        const items = []
        const porquesErrados = difference(this.porques, [this.selectedPorque])

        porquesErrados.map(el => {
          items.push(new Item('value', WordTypes.substantivo_comum.value, el))
        })

        //adicioanando porque certo
        const value_items_attributes = [
          new Item(
            'value',
            this.WordTypes.substantivo_comum.value,
            this.selectedPorque
          )
        ]
        items.push(
          new Item(
            'key',
            WordTypes.frase.value,
            word.text,
            null,
            value_items_attributes
          )
        )
        Vue.set(this, 'items', items)

        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit('submitTemplate')
        }, 600)
      } catch (e) {
        this.$notify({
          group: 'danger',
          title: 'Falha',
          text: e.message
        })

        this.busy = false
      }
    },
    updatePorque(value) {
      this.selectedPorque = value
    }
  },
  mounted() {
    this.$emit('defaultActionsVisibilty', false)
  }
}
</script>

<style lang="scss">
#uso-porques {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .correct-items,
  .incorrect-items {
    @include template-editor-field;
    margin: $gap 0px;
    margin-bottom: $gap;
    &-input-group {
      margin-bottom: 30px;
    }
  }
}
</style>
