<template>
  <div id="template-description" class="template-description container-fluid">
    <div class="row">
      <div class="col-md-7">
        <div class="template-description-input-group">
          <div class="label">Enunciado:</div>
          <v-select
            :value="input"
            :options="descriptions"
            placeholder="Selecionar"
            label="text"
            @input="updateDescription"
          >
            <div slot="no-options">
              <span class="vs__no-options-title">Nenhum enuciado foi encontrado:</span>
              <button
                class="btn btn-xs btn-default vs__no-options-action-button"
                @click.prevent="openCreateDescription"
              >Criar novo enunciado</button>
            </div>
          </v-select>
          <modal :name="modalId" height="auto">
            <ls-modal-create-description
              :text="searchWord"
              @close="closeNewWord"
              :image-visible="false"
            />
          </modal>
        </div>
      </div>
      <div class="col-md-5">
        <div v-show="input" class="panel panel-default panel--player">
          <vue-plyr ref="plyr">
            <audio />
          </vue-plyr>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import shortid from 'shortid'
import { mapState } from "vuex";
import axios from "axios";
import { filter, find } from "lodash";
import CreateDescription from "../modals/CreateDescriptionModal";
export default {
  model: {
    prop: "input",
    event: "change"
  },
  props: {
    input: null,
    template: {}
  },
  data() {
    return {
      descriptions: [],
      modalId: shortid.generate(),
      searchWord: '',
      selectedItem: ''
    };
  },
  computed: {
    getAudioUrl() {
      return this.input ? `${this.input.audio.url}` : null;
    },
    player() {
      return this.$refs.plyr.player;
    }
  },
  methods: {
    updateDescription(value) {
      this.$emit("change", value)
    },
    openCreateDescription() {
      this.$modal.show(this.modalId)
    },
    closeNewWord(data){
      if (data && !this.isFilled) {        
        this.selectedItems =  data.text
      }
      this.$modal.hide(this.modalId)
      this.refreshDescriptions()   
    
    },
    async fetchDescriptions() {
      const { data } = await axios.get("/question/descriptions.json");
      return data;
    },
     async refreshDescriptions() {
      this.descriptions = await this.fetchDescriptions();

      this.updateDescription(
        find(this.descriptions, { text: this.selectedItems })
      );
    } 
  },
  watch: {
    input() {
      if (!this.input) return;

      this.player.source = {
        type: "audio",
        title: this.input.text,
        sources: [
          {
            src: this.getAudioUrl,
            type: "audio/mp3"
          }
        ]
      };
    },
    async template() {
      const data = await this.fetchDescriptions();
      this.updateDescription(
        find(data, { text: this.template.question_description })
      );
    }
  },
  async mounted() {
    this.descriptions = await this.fetchDescriptions();

    this.updateDescription(
      find(this.descriptions, { text: this.template.question_description })
    );
  }
};
</script>

<style lang="scss">
.template-description {
  @include template-editor-field;
  &-input-group {
    display: flex;
    align-items: center;
    .v-select {
      flex: 3;
    }
  }
}
</style>