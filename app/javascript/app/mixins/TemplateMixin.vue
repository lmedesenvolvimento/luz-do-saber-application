<script>
import Vue from 'vue'
import { debounce, values, isFunction } from 'lodash'
import { WordTypes } from '../types'
import Templates from '../components/templates/templates.json'
import Item from '../models/Item'

export default {
  props: {
    updateItems: {
      type: 'event'
    },
    template: {
      type: String
    },
    isEditing: {
      type: Boolean,
      default: false
    },
    fetchParentItems: {
      type: Function,
      default: null
    },
    rawItems: {
      type: Array
    }
  },
  data() {
    return {
      items: [],
      words: [],
      word_type: WordTypes.substantivo_comum.value,
      searchable: true,
      limitLenghtWords: null
    }
  },
  computed: {
    WordTypes() {
      return WordTypes
    },
    rawItemsKeys() {
      // keys
      if (this.isEditing) return this.rawItems.filter(i => i.type === 'key')
      else return undefined
    },
    rawItemsValues() {
      // values que NÃO estão ligados a keys
      if (this.isEditing)
        return this.rawItems.filter(i => i.type === 'value' && !i.key_id)
      else return undefined
    },
    rawItemsValuesByKey() {
      //values que estão ligados a keys
      if (this.isEditing) return this.rawItems.filter(i => i.type === 'value')
      else return undefined
    },
    generateInputValues() {
      if (this.isEditing) {
        return this.rawItemsValues.map(i => {
          return {
            text: i.word_text,
            images: i.word_images,
            remote_image_url: i.remote_image_url
          }
        })
      } else return undefined
    },
    generateInputKeys() {
      if (this.isEditing) {
        return this.rawItemsKeys.map(i => {
          return {
            text: i.word_text,
            images: i.word_images,
            remote_image_url: i.remote_image_url
          }
        })
      } else return undefined
    },
    type() {
      if (typeof this.word_type === 'object') {
        return this.word_type ? this.word_type.value : -1
      }
      return this.word_type
    },
    types() {
      return values(WordTypes)
    },
    theKey: {
      get() {
        return this.items.filter(i => i.type === 'key')[0]
      },
      set(newValue) {
        this.items = newValue
      }
    },
    maxItems() {
      const template = Templates.find(t => t.templateName === this.template)
      return template ? template.maxItems : 1
    },
    hasDescription() {
      return this.$parent.hasDescription
    }
  },
  methods: {
    updateSubtitle(subtitle) {
      this.$emit('updateSubtitle', subtitle)
    },
    onChangeItemValue() {
      this.$emit('updateItems', this.items)
      this.validateItems()
      this.validateSearchable()
    },
    changeImageOnUpdate() {
      this.$root.$on('word:select:image', ({ word, image }) => {
        const imagesIndex = this.images.findIndex(
          i => i.word_text === word.text
        )
        this.images[imagesIndex].remote_image_url = image.url
      })
    },
    getImageUrl(images, remote_audio_url) {
      if (remote_audio_url) return remote_audio_url
      else if (images[0]) return images[0]?.url
      else return null
    },
    onSearch(search, loading, wordType) {
      // block ui
      loading(true)
      // fetch options in api
      this.search(loading, search, this, wordType)
    },
    validateSearchable() {
      // please overwrite in template if use word-search
      return true
    },
    validateItems() {
      // please overwrite in template for correct validation
      this.$emit('validateItems', true)
    },
    clear() {
      Vue.set(this, 'words', [])
    },
    /**
     * returns array with types values filled in typesKeys
     */
    typesArray(typesKeys) {
      return typesKeys.map(key => WordTypes[key].value)
    },
    search: debounce(async (loading, search, vm, wordType) => {
      if (vm.searchable) {
        // tinha um escape aqui que impedia certas pesquisas
        const json = `/words.json`
        const queryText = `q[text_cont]=${search}`
        let uri = `${json}?${queryText}`

        // if is more than one type loop through and concat filters
        if (Array.isArray(wordType)) {
          wordType.forEach(type => (uri += `&q[type_in][]=${type}`))
        } else {
          uri += `&q[type_eq]=${wordType || vm.type}`
        }

        let { data } = await vm.$axios.get(uri)
        // filtrando o array pelo total maximo de letras permitido
        if (vm.limitLenghtWords) {
          data = data.filter(el => el.info.total_letters <= vm.limitLenghtWords)
        }

        vm.words = data
      } else {
        vm.words = []
      }
      loading(false)
    }, 350)
  },
  watch: {
    items: {
      deep: true,
      handler() {
        this.onChangeItemValue()
      }
    },
    'theKey.word_text'(newVal, oldVal) {
      if (!oldVal) {
        return
      }
      if (newVal) {
        delete this.theKey.id
      }
    }
  },
  created() {
    const hasParentItems = isFunction(this.fetchParentItems)

    if (!hasParentItems) {
      return
    }

    const items = this.fetchParentItems()

    this.$set(this, 'items', items)
  }
}
</script>
