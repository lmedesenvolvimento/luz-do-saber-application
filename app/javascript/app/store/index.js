import Vuex from 'vuex'
import templates from './modules/templates'
import groups from './modules/groups'

const state = {
  isEditWordModalVisible: false,
  word: null
}

const actions = {
  setWord({ commit }, word) {
    commit('SetWord', word)
  },
  openEditWordModal({ commit }) {
    commit('SetEditWordModal', true)
  },
  closeEditWordModal({ commit }) {
    commit('SetEditWordModal', false)
  }
}

const mutations = {
  SetWord(state, word) {
    state.word = word
  },
  SetEditWordModal(state, bool) {
    state.isEditWordModalVisible = bool
  }
}

const store = new Vuex.Store({
  modules: {
    groups,
    templates
  },
  state,
  actions,
  mutations
})

export default store;