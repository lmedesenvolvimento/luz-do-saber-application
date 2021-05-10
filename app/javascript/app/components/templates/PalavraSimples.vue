<template>
  <div id="palavra-simples">
    <div class="type">
      <div class="row">
        <div class="col-md-7">
          <div class="type-input-group">
            <label class="label">Tipo</label>
            <span class="input">
              <v-select
                v-model="word_type"
                :filterable="false"
                :options="types"
                label="label"
                placeholder="Selecionar"
              />
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="alternatives">
      <div class="row">
        <div class="col-md-7">
          <div class="alternatives-input-group">
            <label class="label">Palavra</label>
            <ls-select-word
              v-model="theKey.word_text"
              @input="onInput"
              :type="type"
            />
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import { clone, values } from "lodash";
import { WordTypes } from "../../types";
import TemplateMixin from "../../mixins/TemplateMixin";

import Item from "../../models/Item";

const templateTypes = [
  WordTypes.substantivo_comum.value,
  WordTypes.substantivo_proprio.value,
];

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.substantivo_comum,
      items: [],
      invalid: false,
    };
  },
  computed: {
    types() {
      return values(WordTypes).filter((t) => templateTypes.includes(t.value));
    },
  },
  methods: {
    createItems() {
      const items = [];

      items.push(new Item("key", this.type, ""));

      Vue.set(this, "items", items);
    },
    onInput({ text, images }) {
      if (this.theKey && this.theKey.value_items_attributes) {
        this.theKey.text = text;
        this.theKey.remote_image_url = images[0].url;
        this.theKey.value_items_attributes[0].word_text = text;
        this.theKey.value_items_attributes[0].text = text;
        this.theKey.value_items_attributes[0].remote_image_url = images[0].url;
      }

      Vue.set(this, "items", [this.theKey]);
    },
    validateItems() {
      this.$emit("validateItems", !!this.theKey.word_text);
    },
  },
  watch: {
    word_type() {
      this.createItems();
    },
  },
  created() {
    if (!this.items.length > 0) {
      this.createItems();
    }
  },
  mounted() {
    if (this.isEditing) {
      this.type = this.theKey.word_type;
    }
  },
};
</script>

<style lang="scss">
#palavra-simples {
  .type,
  .alternatives {
    @include template-editor-field;
  }
  .alternatives {
    .label {
      align-self: flex-start;
    }
  }
}
</style>
