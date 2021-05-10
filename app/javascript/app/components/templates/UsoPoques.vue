<template>
  <div id="uso-porques">
    <div class="row">
      <div class="col-md-7">
        <ls-modal-create-word
          ref="embedded"
          :embedded="true"
          :text="initialText"
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
    <div class="row">
      <div class="col-md-7">
        <div class="items-input-group select-multiple incorrect-items-input-group">
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
    <div class="actions">
      <router-link
        tag="button"
        class="btn btn-default"
        :to="{ name: 'templates' }"
        :disabled="busy"
      >Cancelar</router-link>
      <button
        @click="submit"
        class="btn btn-primary"
        :disabled="busy || isSubmitDisabled"
      >Criar Atividade</button>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import { clone } from "lodash";
import TemplateMixin from "../../mixins/TemplateMixin";

import Item from "../../models/Item";
import Word from "../../models/Word";

import { WordTypes } from "../../types";

import CreateWordModal from "../../modals/CreateWordModal";

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      busy: false,
      word_type: WordTypes.frase.value,
      items: [],
      porques: ["Porque", "Por que", "Porquê", "Por quê"],
      selectedPorque: null,
      initialText: null,
      initialPorque: null,
    };
  },
   created() {
    if(this.items.length > 0) {     
     this.items.map((el, index) => {
       if (el.type === "key") {
         this.initialText = el.text
         this.initialPorque = el.value_items_attributes[0].text
         this.selectedPorque = this.initialPorque
       } 
      })
    }
  },
  computed: {
    isSubmitDisabled() {
      return !this.$parent.hasDescription;
    }
  },
  methods: {
    async submit() {
      try {
        this.busy = true;
        // Aguardando nova palavra ser criada
        const { data } = await this.$refs.embedded.submit();
        const word = data;

        //adicioando porques errados
        const index = this.porques.indexOf(this.selectedPorque);
        
        const porquesErrados = clone(this.porques);
        if (index > -1) {
          porquesErrados.splice(index, 1);
        }
        
        for (let i = 0; i < porquesErrados.length; i++) {
          this.items.push(
            new Item(
              "value",
              WordTypes.substantivo_comum.value,
              porquesErrados[i],
            )
          );
        }

        //adicioanando porque certo
        const value_items_attributes = [
          new Item(
            "value",
            this.WordTypes.substantivo_comum.value,
            this.selectedPorque
          )
        ];

        this.items.push(
          new Item(
            "key",
            WordTypes.frase.value,
            word.text,
            null,
            value_items_attributes
          )
        );

        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit("submitTemplate");
        }, 400);
      } catch (e) {
        this.$notify({
          group: "danger",
          title: "Falha",
          text: e.message
        });

        this.busy = false;
      }
    },
    updatePorque(value) {
      this.selectedPorque = value;
    }
  },
  mounted() {
    this.$emit("defaultActionsVisibilty", false);
  }
};
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