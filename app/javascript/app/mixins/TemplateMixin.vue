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
    }
  },
  data() {
    return {
      items: [],
      words: [],
      word_type: WordTypes.substantivo_comum.value,
      searchable: true
    }
  },
  computed: {
    WordTypes() {
      return WordTypes
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
      const template = Templates.find((t) => t.templateName === this.template)
      return template ? template.maxItems : 1
    },
    hasDescription() {
      return this.$parent.hasDescription
    }
  },
  methods: {
    onChangeItemValue() {
      this.$emit('updateItems', this.items)
      this.validateItems()
      this.validateSearchable()
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
    search: debounce(async (loading, search, vm, wordType) => {
      if (vm.searchable) {
        // tinha um escape aqui que impedia certas pesquisas
        const uri = `/words.json?q[type_eq]=${wordType || vm.type}&q[text_cont]=${search}`
        const { data } = await vm.$axios.get(uri)
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
         
    },
  },
  created(){
    const hasParentItems = isFunction(this.fetchParentItems)
    
    if (!hasParentItems) {
      return
    }

    const items = this.fetchParentItems()

    this.$set(this, 'items', items)
  }
}
</script>
