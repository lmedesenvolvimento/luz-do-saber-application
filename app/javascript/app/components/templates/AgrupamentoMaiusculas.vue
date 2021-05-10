<template>
  <div id="agrupamento-maiusculas">
    <div class="letras">
      <div class="row">
        <div class="col-md-7">
          <div class="letras-input-group">
            <label class="label is-top">Letras</label>
            <span class="input">
              <ls-select-letters :max-items="6" @change="onInput" :initial-letras="initialLetras" />
            </span>
          </div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import { clone } from "lodash";
import Item from "../../models/Item";
import TemplateMixin from "../../mixins/TemplateMixin";
import { WordTypes } from "../../types";
export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      invalid: false,
      size: false,
      values_atributes: [],
      initialLetras: []
    };
  },
  created() {
    if(this.isEditing) {
      console.log('entrou aqui')
     this.initialLetras = this.items[0].value_items_attributes.map((el) => {
        return el.text
      })
    }
  },
  methods: {
    onInput({ data, invalid }) {
      const alternatives = data;
      const cloneItems = [];

      if (data.length >= 1) {
        this.size = true;
        this.validateItems();
      } else {
        this.size = false;
        this.validateItems();
      }

      this.values_atributes = [];
      alternatives.map(({ text }) => {
        if (!text) {
          return;
        }
        this.values_atributes.push(
          new Item("value", this.WordTypes.letra.value, text)
        );
      });

      cloneItems.push(
        new Item(
          "key",
          WordTypes.substantivo_comum.value,
          "MAIÚSCULAS",
          "https://i.ibb.co/6v1mK8S/caixa-2.png",
          this.values_atributes
        )
      );

      Vue.set(this, "items", cloneItems);
    },
    validateItems() {
      this.$emit("validateItems", this.size);
    },
  },
};
</script>

<style lang="scss">
#agrupamento-maiusculas {
  .letras {
    @include template-editor-field;
  }
}
</style>