<template>
  <div id="template-description" class="template-description container-fluid">
    <div class="row">
      <div class="col-md-7">
        <div class="template-description-input-group">
          <div class="label">{{ descriptionText }}:</div>
          <v-select
            :value="input"
            :options="descriptions"
            placeholder="Selecionar"
            label="text"
            @input="updateDescription"
          >
            <div class="btn-create-description" slot="list-header">
              <button
                class="btn btn-xs btn-default"
                @click.prevent="openCreateDescription"
              >
                Criar novo {{ descriptionText }}
              </button>
            </div>
            <div slot="no-options">
              <span class="vs__no-options-title">
                Nenhum {{ descriptionText }} foi encontrado:
              </span>
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
        <div v-if="optional">(Opcional)</div>
      </div>
      <div class="col-md-5">
        <div
          v-show="input && containsAudio"
          class="panel panel-default panel--player"
        >
          <vue-plyr ref="plyr">
            <audio />
          </vue-plyr>
        </div>
        <div
          v-show="!containsAudio && input && loading"
          class="not-contains-enun"
        >
          *Esse {{ descriptionText }} não contém áudio.
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import shortid from 'shortid'
import axios from 'axios'
import { find } from 'lodash'

export default {
  model: {
    prop: 'input',
    event: 'change'
  },
  props: {
    input: {
      type: [String, Object],
      default: null
    },
    descriptionText: {
      type: String,
      default: 'enunciado'
    },
    descriptionType: {
      type: String,
      default: 'texto',
      validator: value => ['texto', 'subtitle'].indexOf(value) !== -1
    },
    template: {
      type: [String, Object]
    },
    optional: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  data() {
    return {
      descriptions: [],
      modalId: shortid.generate(),
      searchWord: '',
      selectedItem: '',
      containsAudio: false,
      loading: false
    }
  },
  computed: {
    getAudioUrl() {
      return this.input ? `${this.input.audio_full_url}` : null
    },
    player() {
      return this.$refs.plyr.player
    }
  },
  methods: {
    updateDescription(value) {
      this.$emit('change', value)
    },
    openCreateDescription() {
      this.$modal.show(this.modalId)
    },
    closeNewWord(data) {
      if (data && !this.isFilled) {
        this.selectedItems = data.text
      }
      this.$modal.hide(this.modalId)
      this.refreshDescriptions()
    },
    async fetchDescriptions() {
      const { data } = await axios.get('/question/descriptions.json')
      return data.filter(data => data.type === this.descriptionType)
    },
    async refreshDescriptions() {
      this.descriptions = await this.fetchDescriptions()

      this.updateDescription(
        find(this.descriptions, { text: this.selectedItems })
      )
    }
  },
  watch: {
    async input() {
      if (!this.input) return

      //verificando de o enunciado contém audio
      const containsAudio = await fetch(this.getAudioUrl).then(resp => {
        return resp.ok
      })
      this.containsAudio = containsAudio

      this.player.source = {
        type: 'audio',
        title: this.input.text,
        sources: [
          {
            src: this.getAudioUrl,
            type: 'audio/mp3'
          }
        ]
      }
    },
    async template() {
      if (this.template) {
        const data = await this.fetchDescriptions()
        this.updateDescription(
          find(data, { text: this.template.question_description })
        )
      }
    }
  },
  async mounted() {
    this.descriptions = await this.fetchDescriptions()

    if (this.template) {
      this.updateDescription(
        find(this.descriptions, { text: this.template.question_description })
      )
    }
    this.loading = true
  }
}
</script>

<style lang="scss">
.template-description {
  @include template-editor-field;
  &-input-group {
    display: flex;
    align-items: center;
    .v-select {
      flex: 3 !important;
    }
  }
  .not-contains-enun {
    height: 34px;
    display: flex;
    align-items: center;
    font-style: italic;
  }

  .btn-create-description {
    display: flex;
    justify-content: flex-end;
    padding: 5px 8px 10px 8px;
  }
  .label {
    text-transform: Capitalize;
  }
}
</style>
