<template>
  <div id="palavras-com-imagem">
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
    <div class="palavra-items">
      <div class="row">
        <div class="col-md-7">
          <ls-select-multiple
            class="correct-items-input-group"
            ref="select"
            :options="words"
            :max-items="maxItems"
            :initial-items="initialItems"
            :word-type="word_type.value"
            label="Palavras:"
            @search="onSearch"
            @search:focus="clear"
            @input="addItem"
          />
          
          <div v-if="maxItems <= 1">({{ maxItems }} item)</div>
          <div v-else>({{ maxItems }} itens)</div>
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
    <div class="images-items">
      <div class="row">
        <div class="col-md-12">
          <div class="correct-items-input-group">
            <div v-if="maxItems <= 1" class="label">Imagem:</div>
            <div v-else class="label">Imagens:</div>
            <ls-images-holder :items="images"></ls-images-holder>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import { clone, values } from "lodash";
import Item from "../../models/Item";
import Templates from "../../components/templates/templates.json";
import TemplateMixin from "../../mixins/TemplateMixin";

import { WordTypes } from "../../types";

const templateTypes = [
  WordTypes.substantivo_comum.value,
  WordTypes.substantivo_proprio.value,
];

export default {
  mixins: [TemplateMixin],
  data() {
    return {
      items: [],
      images: [],
      initialItems: [],
      word_type: WordTypes.substantivo_comum
    };
  },
  computed: {
    types() {
      return values(WordTypes).filter((t) => templateTypes.includes(t.value));
    },
    typeSelect() {
      return this.word_type.value
    }
  },
  created() {
   // this.types = [this.WordTypes.letra, this.WordTypes.silaba];
  
    if (this.items.length > 0 && this.isEditing) {      
      this.initialItems = this.items.map((el) => {
        if (el.word_type === 2) {
          this.word_type = WordTypes.substantivo_proprio
        } else {
          this.word_type = WordTypes.substantivo_comum
        }
        return { text: el.text};
      });
    }
  },
  async mounted() {
    let type_eq = ''
    let text_cont = '' 
    let new_array = [] 

    if (this.items.length > 0 && this.isEditing) {
      if (this.items.length > 1) {
        this.items.map(async (el) => {
          type_eq = el.word_type
          text_cont = el.text
          const response = await this.$axios.get(`/words.json?q[type_eq]=${type_eq}&q[text_cont]=${text_cont}`)
          new_array.push(response.data[0])  
          this.addItem(new_array) 
          this.initialItems = new_array       
         }); 
      } else {
      this.items.map(async (el) => {
        type_eq = el.word_type
        text_cont = el.text
         const response = await this.$axios.get(`/words.json?q[type_eq]=${type_eq}&q[text_cont]=${text_cont}`)
        
        this.addItem(response.data)
      });
      }
    }
  },
  methods: {
    addItem(alternatives) {
      // Example for mapping incorrect inputs
      const items = alternatives.map(({ text, images}) => {
        return new Item(
          "key",
          this.WordTypes.substantivo_comum.key,
          text,
          images[0]
        );
      });

      this.images = items;
      const modeledItem = items.map(({ remote_image_url, ...i }) => i);
      Vue.set(this, "items", modeledItem);
    },
    validateSearchable() {
      this.searchable = this.items.length < this.maxItems;
    },
    validateItems() {
      this.$emit("validateItems", this.items.length === this.maxItems);
    },
  },
  watch: {
    type(t){
      if (this.$refs.select && !this.initialItems.length > 0) {
        this.$refs.select.clearSelection()
      }
      this.items = []
      this.initialItems = []  
      this.images = []    
    }
  }
};
</script>

<style lang="scss">
#palavras-com-imagem {
   .type, .alternatives {
    @include template-editor-field;
  }

  .ls-images-holder {
    display: flex;
    align-items: flex-end;
    justify-content: flex-start;
    max-width: 86%;
  }

  .ls-images-holder,
  .v-select {
    flex: 6;
  }

  .palavra-items {
    padding: 16px 0px;
  }
  .correct-items,
  .incorrect-items {
    @include template-editor-field;
    margin: $gap 0px;
  }
}
</style>
