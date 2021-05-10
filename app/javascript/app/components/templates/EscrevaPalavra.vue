<template>
  <div id="escreva-palavra">
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
            v-model="input"
            label="Palavras:"
            @search="onSearch"
            @search:focus="clear"
            @input="addItem"
          />

          <div v-if="maxItems <= 1">({{ maxItems }} item)</div>
          <div v-else>({{ maxItems }} itens)</div>
        </div>
        <div class="col-md-5">
          <div
            v-show="input.length > 0"
            class="panel panel-default panel--player"
          >
            <vue-plyr ref="plyr">
              <audio />
            </vue-plyr>
          </div>
        </div>
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
      word_type: WordTypes.substantivo_comum,
      input: [],
    };
  },
  computed: {
    types() {
      return values(WordTypes).filter((t) => templateTypes.includes(t.value));
    },
    typeSelect() {
      return this.word_type.value;
    },
    getAudioUrl() {
      return this.input ? `${this.input[0].audios[0].url}` : null;
    },
    player() {
      return this.$refs.plyr.player;
    },
  },
  created() {
    // this.types = [this.WordTypes.letra, this.WordTypes.silaba];

    if (this.items.length > 0 && this.isEditing) {
      this.initialItems = this.items.map((el) => {
        if (el.word_type === 2) {
          this.word_type = WordTypes.substantivo_proprio;
        } else {
          this.word_type = WordTypes.substantivo_comum;
        }
        return { text: el.text };
      });
    }
  },
  async mounted() {
    if (this.items.length > 0 && this.isEditing) {
      this.items.map(async (el) => {
        if (el.type === "key") {
          const response = await this.$axios.get(
            `/words.json?q[type_eq]=${el.word_type}&q[text_cont]=${el.text}`
          );
          this.input = response.data;
          this.addItem(response.data);
        }
      });
    }
  },
  methods: {
    addItem(alternatives) {
      // Example for mapping incorrect inputs
      const items = alternatives.map(({ text, images }) => {
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
    type(t) {
      if (this.$refs.select && !this.initialItems.length > 0) {
        this.$refs.select.clearSelection();
      }
      this.items = [];
      this.initialItems = [];
      this.images = [];
    },
    input() {
      if (!this.input[0]) return;

      this.player.source = {
        type: "audio",
        title: this.input[0].text,
        sources: [
          {
            src: this.getAudioUrl,
            type: "audio/mp3",
          },
        ],
      };
    },
  },
};
</script>

<style lang="scss">
#escreva-palavra {
  .type,
  .alternatives {
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
