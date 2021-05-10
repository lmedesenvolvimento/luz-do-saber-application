import Vue from 'vue'
import { find } from 'lodash'

const state = {
  data: []
}

const mutations = {
  fetch(state, data) {
    state.data = data
  },
  setGroup(state, data) {
    Vue.set(state, 'template', Object.assign({}, state.group, data))
  }
}

const actions = {
  fetch({ commit }, data) {
    commit('fetch', data)
  }
}

const getters = {
  getGroup: state => id => find(state.data, t => t.id.toString() === id)
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}