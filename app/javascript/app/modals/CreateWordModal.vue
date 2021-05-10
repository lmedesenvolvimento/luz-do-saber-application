<template>
  <div v-if="word" class="ls-modal" :class="{ 'is-embedded': embedded }">
    <form class="ls-modal-form form-inline">
      <div class="ls-modal-header">
        <div class="title">Nova Palavra {{ wordType }}</div>
      </div>
      <div class="ls-modal-content">
        <div v-show="textVisible" v-if="wordTypeVisible" class="form-group">
          <label>Tipo:</label>
          <span class="input">
            <select
              v-model="word.type"
              :disabled="wordTypeDisabled"
              class="form-control"
            >
              <option v-for="type in types" :key="type.key" :value="type.value">
                {{ type.label }}
              </option>
            </select>
          </span>
        </div>

        <div v-if="word && word.type" class="fields">
          <div
            v-show="textVisible"
            class="form-group"
            :class="{ 'has-error': errors.text }"
          >
            <slot name="word" :word="word">
              <label :class="{ 'is-sentence': isLong }">
                {{ getWordTypeLabel }}
              </label>
              <span class="input">
                <textarea
                  v-if="isLong"
                  v-model="word.text"
                  class="form-control"
                  rows="5"
                />
                <input v-else v-model="word.text" class="form-control" />
              </span>
            </slot>
            <p v-if="errors.text" class="text-danger feedback">
              Campo Obrigatório *
            </p>
          </div>

          <div v-if="!isLong" class="form-group">
            <label>Quant. de sílabas:</label>
            <span class="input">
              <ls-input-number-syllables v-model="word.total_syllables" />
            </span>
          </div>

          <div
            v-if="!isLong"
            class="form-group"
            :class="{ 'has-error': errors.syllables }"
          >
            <label class="is-sentence">Separação silábica:</label>
            <span class="input">
              <ls-input-syllables
                v-model="word.syllables"
                :total-syllables="word.total_syllables"
              />
            </span>
            <p v-if="errors.syllables" class="text-danger feedback">
              Separação silábica e texto não coincidem *
            </p>
          </div>

          <div
            v-if="imageVisible && !isSubstantivoProprio"
            class="form-group"
            :class="{ 'has-error': errors.image }"
          >
            <label>Imagem:</label>
            <span class="input">
              <ls-input-file
                v-model="image.attachment"
                :placeholder="imagePlaceholder"
                :invalid="errors.image"
                accept="image/*"
              >
                <i class="icon icon-upload-solid"></i> Selecionar Arquivo
              </ls-input-file>
            </span>
            <p v-if="errors.image" class="text-danger feedback">
              Campo Obrigatório *
            </p>
          </div>

          <div
            v-if="audioVisible && !isSubstantivoProprio"
            class="form-group"
            :class="{ 'has-error': errors.audio }"
          >
            <label>Audio:</label>
            <span class="input">
              <ls-input-file
                v-model="audio.attachment"
                :placeholder="audioPlaceholder"
                :invalid="errors.audio"
                accept="audio/mp3,audio/mpeg"
              >
                <i class="icon icon-upload-solid"></i> Selecionar Arquivo
              </ls-input-file>
            </span>
          </div>
        </div>
      </div>
      <div class="ls-modal-footer">
        <button
          @click="close"
          type="button"
          class="btn btn-default"
          :disabled="busy"
        >
          Cancelar
        </button>

        <button
          @click="submit"
          type="button"
          class="btn btn-primary"
          :disabled="busy"
        >
          Salvar
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import Vue from "vue";
import { clone, values, find, omit } from "lodash";
import objectToFormData from "object-to-formdata";

import { WordTypes } from "../types";
import ActiveRecordHelper from "../utils/activerecord";
import Word from "../models/Word";

const longTexts = ["frase", "texto", "input_custom"];

const permittedTypes = [
  "substantivo_proprio",
  "substantivo_comum",
  "frase",
  "texto",
  "input_custom",
];

const unpermitted_params = [
  "id",
  "total_syllables",
  "syllables",
  "info",
  "images",
  "audios",
];

export default {
  props: {
    text: {
      type: [String, Array],
      default: null,
    },
    embedded: {
      type: Boolean,
      default: false,
    },
    wordType: {
      type: Number,
      default: null,
    },
    wordTypeLabel: {
      type: String,
      default: null,
    },
    wordTypeDisabled: {
      type: Boolean,
      default: false,
    },
    audioRequired: {
      type: Boolean,
      default: false,
    },
    textRequired: {
      type: Boolean,
      default: true,
    },
    textVisible: {
      type: Boolean,
      default: true,
    },
    imageRequired: {
      type: Boolean,
      default: false,
    },
    audioVisible: {
      type: Boolean,
      default: true,
    },
    imageVisible: {
      type: Boolean,
      default: true,
    },
    wordTypeVisible: {
      type: Boolean,
      default: true,
    },
    isEditing: {
      type: Boolean,
      default: false,
    },
    isItem: {
      type: Boolean,
      default: false,
    },
    wordId: {
      type: Number,
      default: null,
    },
    labelText: {
      type: String,
      default: null,
    },
  },
  data() {
    return {
      word: null,
      audio: {},
      image: {},
      errors: {},
      busy: false,
    };
  },
  computed: {
    types() {
      return values(WordTypes).filter((type) =>
        permittedTypes.includes(type.key)
      );
    },
    isLong() {
      const indexOf = this.word.type;
      const { key } = find(this.types, { value: this.word.type });

      return longTexts.includes(key);
    },
    isSubstantivoProprio() {
      return (
        this.word.type && this.word.type === WordTypes.substantivo_proprio.value
      );
    },
    hasError() {
      return values(this.errors).some((bool) => bool);
    },
    getWordTypeLabel() {
      if (this.wordTypeLabel) {
        return this.wordTypeLabel;
      }
      if (this.labelText) {
        return this.labelText;
      }
      return this.isLong ? "Texto:" : "Palavra:";
    },
    imagePlaceholder() {
      if (this.isItem) {
        return "Arquivo Selecionado";
      }
      if (this.isEditing) {
        return this.word.images.length ? this.word.images[0].url : "";
      }
      return "";
    },
    audioPlaceholder() {
      if (this.isEditing) {
        return this.word.audios.length ? this.word.audios[0].url : "";
      }
      return "";
    },
  },
  created() {
    if (this.isEditing || this.word) {
      return true;
    }

    const word = new Word();

    word.text = this.text;

    word.total_syllables = 1;
    word.syllables = [];

    if (this.wordType) {
      word.type = this.wordType;
    }

    Vue.set(this, "word", word);
  },
  methods: {
    async submit() {
      this.validates();

      this.busy = true;

      if (this.hasError) {
        this.busy = false;
        this.$notify({
          group: "danger",
          title: "Falha na Validação",
          text: "Por favor verifique no formulário a causa e o motivo",
        });
        return { error: true };
      }

      const payload = this.mapWord();
      const formBody = objectToFormData(payload, { indices: true });

      try {
        const { data } = await this.$axios({
          url: this.isEditing ? `/words/${this.wordId}.json` : "/words.json",
          method: this.isEditing ? "put" : "post",
          data: formBody,
          headers: { "Content-Type": "multipart/form-data" },
        });

        if (data.errors) {
          const message = ActiveRecordHelper.errorMessage(data.errors);
          throw new Error(message);
        }

        this.$notify({
          group: "success",
          title: "Sucesso",
          text: "Nova palavra  criada com sucesso!",
        });

        this.$emit("close", data);

        return { data };
      } catch (error) {
        if (this.embedded) {
          // TEMPORÁRIO Caso a palavra já exista
          if (error.message === "text - já está em uso") {
            let data = { text: this.word.text };
            this.$emit("close", { data }); // emitindo para o parent
            return { data };
          }

          throw new Error(error);
        } else {
          this.$notify({
            group: "danger",
            title: "Falha na Validação",
            text: error.message,
          });
        }

        this.busy = false;

        return { error: true, data: error };
      }
    },
    validates() {
      const { syllables } = this.word;

      const errors = {};

      if (!this.textRequired) {
        const letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVXZ";
        let prefix = "INPUT-";
        for (let i = 0; i < 10; i++) {
          prefix += letters[Math.floor(Math.random() * 33)];
        }
        this.word.text = prefix;
      } else {
        errors.text = !this.word.text;
      }
      errors.syllables = !this.isLong
        ? this.validateSyllables(syllables)
        : false;
      //errors.audio = this.validateAudio();
      //errors.image = this.validateImage();

      Vue.set(this, "errors", errors);
    },
    validateImage() {
      let invalid = null;

      if (this.imageRequired && this.isEditing) {
        invalid = !this.word.images.length;
      }

      if (this.imageRequired) {
        if (invalid) {
          invalid = !this.image.attachment;
        }
        return invalid;
      }

      if (this.isSubstantivoProprio) {
        return false;
      }

      return this.isLong ? false : !this.image.attachment;
    },
    validateAudio() {
      let invalid = false;

      if (this.audioRequired) {
        if (invalid) {
          invalid = !this.audio.attachment;
        }
        return invalid;
      }

      if (this.isSubstantivoProprio) {
        return false;
      }

      return this.isLong ? false : !this.audio.attachment;
    },
    validateSyllables(syllables) {
      return (
        syllables
          .map((s) => s.text)
          .join("")
          .toUpperCase() !== this.word.text.toUpperCase()
      );
    },
    close() {
      this.$emit("close", false);
    },

    mapWord() {
      let payload = { word: { ...this.word } };
      const types = values(WordTypes);
      const syllables = this.word.syllables
        ? this.word.syllables.filter((s) => s.text)
        : [];

      if (syllables.length) {
        payload.word.elements_attributes = syllables.map(({ text }) => {
          return {
            text: text.toUpperCase(),
            type: WordTypes.silaba.key,
          };
        });
      }

      if (this.image.attachment) {
        if (this.isEditing) {
          payload.word.images_attributes = [];

          payload.word.images_attributes.push(omit(this.image, ["url"]));

          if (this.word.images.length) {
            this.word.images.forEach((i) => {
              payload.word.images_attributes.push({ id: i.id, _destroy: "1" });
            });
          }
        } else {
          payload.word.images_attributes = [omit(this.image, ["url"])];
        }
      }

      if (this.audio.attachment) {
        if (this.isEditing) {
          payload.word.audios_attributes = [];

          payload.word.audios_attributes.push(omit(this.audio, ["url"]));

          if (this.word.audios.length) {
            this.word.audios.forEach((a) => {
              payload.word.audios_attributes.push({ id: a.id, _destroy: "1" });
            });
          }
        } else {
          payload.word.audios_attributes = [omit(this.audio, ["url"])];
        }
      }

      // convert integer to enum for active-record persist
      payload.word = omit(payload.word, unpermitted_params);
      payload.word.type = find(types, { value: this.word.type }).key;

      return payload;
    },
  },
  watch: {
    async wordId(word_id) {
      if (this.isEditing && word_id) {
        let { data } = await this.$axios.get(`/words/${word_id}.json`);
        // map word
        data.type = WordTypes[data.type].value;
        this.$set(this, "word", data);
      }
    },
  },
};
</script>

<style lang="scss">
.ls-modal {
  &-header {
    @include nunito_bold;
    background-color: $brand-primary;
    border-bottom: 1px solid $brand-primary;
    padding: $gap * 1.5;
    text-align: center;
    .title {
      font-size: 18px;
      color: white;
      text-transform: uppercase;
    }
  }
  &-footer {
    display: flex;
    justify-content: flex-end;
    padding: $gap ($gap * 2);
    border-top: 1px solid $border-color;
    .btn {
      margin: 0px $gap;
    }
  }
  &-content {
    max-height: 50vh;
    min-height: 200px;
    overflow-x: hidden;
    overflow-y: auto;
    padding: ($gap * 4) ($gap * 2.5);
  }
  &-form {
    .form-group {
      display: flex;
      flex-wrap: wrap;
      box-sizing: border-box;
      width: 100%;
      margin-bottom: $gap * 3;
      .feedback {
        display: block;
        width: 100%;
        margin-top: 4px;
        margin-left: 33%;
        font-size: 10px;
      }
      label {
        max-width: 33.3%;
        flex: 1;
        padding: 0px ($gap * 2);
        align-self: center;
        text-align: right;
        &.is-sentence {
          align-self: flex-start;
        }
      }

      .input {
        flex: 2;
        display: inline-block;
        width: 100%;
        .ls-input-syllables,
        .ls-input-number-syllables {
          padding: 0px;
        }
        .form-control,
        select,
        .input-file {
          width: 100%;
          max-width: 100%;
        }
      }
    }
  }
  &.is-embedded {
    .ls-modal-header,
    .ls-modal-footer {
      display: none;
    }
    .ls-modal-content {
      padding: 0px;
      max-height: none;
      min-height: 0px;
    }
    .ls-modal-form {
      .form-group {
        label {
          flex: 1;
          text-align: left;
          padding: 0;
        }
        .input {
          flex: 3;
        }
      }
    }
  }
}
</style>
