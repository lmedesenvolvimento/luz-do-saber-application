<template>
<div id="selecione-nome">
  <div class="the-word">
    <div class="row">
      <div class="col-md-7">
        <div class="the-word-input-group">
          <label class="label">Palavra:</label>
          <ls-select-word
            v-model="theKey.word_text"
            :type="theKey.word_type"
            @input="onInput"
          />
        </div>
      </div>
    </div>
    <div class="alternatives">
      <div class="row">
        <div class="col-md-7">
          <div class="items-input-group select-multiple incorrect-items-input-group">
            <div class="label">Alternativas </br> Incorretas:</div>
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
          <!-- <ls-select-multiple
            class="alternatives-input-group"
            :options="words"
            :max-items="maxItems"
            label="Alternativas <br> Incorretas"
            :label-html="true"
            @search="onSearch"
            @input="inputIncorrectItem"
          /> -->
        </div>
        <div class="col-md-5"></div>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import Vue from 'vue'
import TemplateMixin from '../../mixins/TemplateMixin'
import { WordTypes } from '../../types'
import Item from '../../models/Item'
export default {
  mixins: [TemplateMixin],
  data() {
    return {
      word_type: WordTypes.substantivo_proprio.value,
      incorrects: [],
    }
  },
  computed: {
    invalid() {
      return this.maxItems.length >= this.items.length 
    },
    searchFeedback() {
      return this.isSearchable
        ? "Digite uma alternativa para continuar..."
        : "Limite máximo de frases foi atigindo.";
    },
    isSearchable() {
      return this.incorrects.length  < 3;
    },
  },
  methods: {
    onInput({text, images}) {
      let newItem = undefined
      if (this.theKey){

        
        const value_items_attributes = [
          new Item('value', WordTypes.substantivo_proprio.value, text)
        ]

        newItem = new Item('key', WordTypes.substantivo_proprio.value, text, null, value_items_attributes)
        // this.theKey.remote_image_url = images[0].url       
        // this.theKey.value_items_attributes[0].word_text = text
        // this.theKey.value_items_attributes[0].text = text
        // this.theKey.value_items_attributes[0].remote_image_url = images[0].url
      }

      Vue.set(this, 'items', [newItem])
    },
    addItemIncorrect(alternatives){
      // Example for mapping incorrect inputs
      const incorrects = alternatives.map((text) => {
        return new Item("value", this.WordTypes.input_custom.value, text);
      });
      // union keys with incorrect items
      this.items = [
        ...this.items.filter(({ type }) => type === 'key'),
        ...incorrects
      ]
    },
    validateItems() {
      this.$emit('validateItems', true)
    }
  },
  created() {
    if(this.isEditing) {
      this.items.map((el)=>{
        if (el.type === 'value') {
          this.incorrects.push(el.text)
          this.addItemIncorrect(this.incorrects)
        }

      })
    } else {
      const value_items_attributes = [
       new Item('value', WordTypes.substantivo_proprio.value, '')
      ]
   value_items_attributes.word_source_type = 'external_param'
    // this.items.push(
    //   new Item('key', WordTypes.substantivo_comum.value, '', null, value_items_attributes)
    // )
    let newItem = new Item('key', WordTypes.substantivo_proprio.value, "", null, value_items_attributes)
    newItem.word_source_type = 'external_param'
    
    // newItem.type = 'key'
    // newItem.word_type = WordTypes.substantivo_proprio.value 
    // newItem.word_source_type = 'external_param'
    // newItem.value_items_attributes = value_items_attributes

    this.items.push(newItem)

    this.$emit('validateItems', true)
    }
    
  }
}
</script>

<style lang="scss">
#selecione-nome{
  .the-word {
    @include template-editor-field;
  }
  .create-word{
    margin-top: $gap * 2;
  }
  .alternatives {
    @include template-editor-field;
    .label {
      align-self: flex-start;
    }
  }
  .actions{
    .btn:first-child {
      margin-right: 5px;
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