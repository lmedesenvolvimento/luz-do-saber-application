import Vue from 'vue'
import vSelect from 'vue-select'

import SelectUnit from './SelectUnit.vue'
import SelectTheme from './SelectTheme.vue'
import SelectGroup from './SelectGroup.vue'

import ItemTemplate from './ItemTemplate.vue'
import TemplateOrder from './TemplateOrder.vue'
import TemplateTitle from './TemplateTitle.vue'
import TemplateDescription from './TemplateDescription.vue'

import WordTypeRadioButton from './items/WordTypeRadioButton.vue'
import SelectWord from './items/SelectWord.vue'
import SelectLetters from './items/SelectLetters.vue'
import SelectMultiple from './items/SelectMultiple.vue'
import SelectSpecialCharacter from './items/SelectSpecialCharacter.vue'

import ImagesHolder from './items/ImagesHolder.vue'
import InputFile from './items/InputFile.vue'
import InputSyllables from './items/InputSyllables.vue'
import InputNumberSyllables from './items/InputNumberSyllables.vue'

import CreateWordModal from '../modals/CreateWordModal.vue'
import CreateImageModal from '../modals/CreateImageModal.vue'
import CreateDescriptionModal from '../modals/CreateDescriptionModal.vue'

const Components = {
    install: (Vue) => {
        Vue.component('v-select', vSelect)

        Vue.component('ls-select-group', SelectGroup)
        Vue.component('ls-select-unit', SelectUnit)
        Vue.component('ls-select-theme', SelectTheme)
        Vue.component('ls-select-word', SelectWord)

        Vue.component('ls-item-template', ItemTemplate)

        Vue.component('ls-template-order', TemplateOrder)
        Vue.component('ls-template-title', TemplateTitle)
        Vue.component('ls-template-description', TemplateDescription)

        Vue.component('ls-wordtype-radio-button', WordTypeRadioButton)
        Vue.component('ls-images-holder', ImagesHolder)
        Vue.component('ls-select-letters', SelectLetters)
        Vue.component('ls-select-multiple', SelectMultiple)
        Vue.component('ls-select-special-character', SelectSpecialCharacter)

        Vue.component('ls-input-file', InputFile)
        Vue.component('ls-input-syllables', InputSyllables)
        Vue.component('ls-input-number-syllables', InputNumberSyllables)

        Vue.component('ls-modal-create-word', CreateWordModal)
        Vue.component('ls-modal-create-image', CreateImageModal)
        Vue.component('ls-modal-create-description', CreateDescriptionModal)
    }
}

Vue.use(Components)
