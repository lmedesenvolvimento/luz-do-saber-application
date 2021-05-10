<template>
  <div id="apresentacao-imagem">
    <div class="row">
      <div class="col-md-7 first">
        <ls-modal-create-word
          ref="correct"
          :embedded="true"
          :is-not-empty="isNotEmpty"
          :word-type="word_type"
          :word-type-disabled="true"
          :text-visible="false"
          :text-required="false"
          :label="'Imagem:'"
          :audio-visible="true"
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
      validate: true,
      isNotEmpty: false,
    };
  },
  computed: {
    searchFeedback() {
      return this.isSearchable
        ? "Digite uma frase para continuar..."
        : "Limite máximo de frases foi atigindo.";
    },

    isSubmitDisabled() {
      return !this.$parent.hasDescription;
    },
  },
  watch: {
    items: {
      handler() {
        if (this.items.length >= 1) {
          this.$emit("submitTemplate");
        }
      },
    },
  },
  methods: {
    async submit() {
      try {
        this.items = [];
        this.busy = true;

        this.submitWord(this.$refs.correct);
      } catch (e) {
        this.busy = false;
      }
    },
    async submitWord(ref) {
      try {
        this.busy = true;
        // Aguardando nova palavra ser criada

        const { data } = await ref.submit();
        const word = data;

        const value_items_attributes = [
          new Item("value", this.WordTypes.input_custom.value, word.text),
        ];

        const items = [
          new Item(
            "key",
            WordTypes.input_custom.value,
            word.text,
            null,
            value_items_attributes
          ),
        ];
        Vue.set(this, "items", items);
      } catch (e) {
        this.busy = false;
      }
    },
  },
  mounted() {
    this.$emit("defaultActionsVisibilty", false);
  },
  created() {
    if (this.items.length > 0) {
      this.isNotEmpty = true;
    }
  },
};
</script>

<style lang="scss">
#apresentacao-imagem {
  .actions {
    .btn:first-child {
      margin-right: 5px;
    }
  }

  .first {
    padding: 16px 16px 25px 16px;
  }

  .actions {
    padding-top: 30px;
  }

  .form-group {
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
