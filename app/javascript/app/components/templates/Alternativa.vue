<template>
  <div id="alternativa">
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div class="items-input-group select-multiple incorrect-items-input-group">
            <div class="label">Alternativas Corretas:</div>
            <v-select
              v-model="correct"
              @input="addItemCorrect"
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
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <div class="items-input-group select-multiple incorrect-items-input-group">
            <div class="label">Alternativas Erradas:</div>
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
        :disabled="busy || !isSubmitDisabled"
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
      word_type: WordTypes.input_custom.value,
      items: [],
      incorrects: [],
      correct: [],
      alternativesCorrects: [],
      alternativesIncorrects: [],
      clonedItem: [],
      validate: true,
      initialCorrects: [],
      initialIncorrects: []
    };
  },
  created() {
    if(this.items.length > 0) {
     this.items.map((el, index) => {
       if (el.value_items_attributes.length > 0) {
         this.initialCorrects.push({text: el.text})
         this.correct.push(el.text)
         this.alternativesCorrects.push(el)
       } else {
         this.initialIncorrects.push({text: el.text})
         this.incorrects.push(el.text)
         this.alternativesIncorrects.push(el)
       }
      })
    }

  },
  computed: {
    searchFeedback() {
      return this.isSearchable
        ? "Digite uma alternativa para continuar..."
        : "Limite máximo de frases foi atigindo.";
    },
    isSearchable() {
      return this.incorrects.length + this.correct.length < 4;
    },
    isSubmitDisabled() {
      return this.$parent.hasDescription && this.items.length > 3;
    },
  },
  methods: {
    addItemIncorrect(alternatives) {
      const incorrects = alternatives.map((text) => {
        return new Item("value", this.WordTypes.input_custom.key, text);
      });
      this.alternativesIncorrects = [...incorrects];
      this.items = [
        ...this.alternativesCorrects,
        ...this.alternativesIncorrects,
      ];
    },
    addItemCorrect(alternatives) {
      const corrects = alternatives.map((text) => {
        const value_items_attributes = new Item(
          "value",
          this.WordTypes.input_custom.key,
          text
        );
        return new Item("key", this.WordTypes.input_custom.key, text, null, [
          value_items_attributes,
        ]);
      });
      this.alternativesCorrects = [...corrects];
      this.items = [
        ...this.alternativesCorrects,
        ...this.alternativesIncorrects,
      ];
    },
    async submit() {
      try {
        this.busy = true;

        // Salvando no banco novo template de questão
        setTimeout(() => {
          this.$emit("submitTemplate");
        }, 400);
      } catch (e) {
        this.$notify({
          group: "danger",
          title: "Falha",
          text: e.message,
        });

        this.busy = false;
      }
    },
  },
  mounted() {
    this.$emit("defaultActionsVisibilty", false);
  },
};
</script>

<style lang="scss">
#alternativa {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .palavra-items {
    margin: 20px 0 30px 0;
  }

  .form-group {
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