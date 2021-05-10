import Vue from 'vue'
import { find } from 'lodash'

const state = {
  data: [],
  template: {}
}

const mutations = {
  fetch(state, data){
    state.data = data
  },
  setTemplate(state, data){
    Vue.set(state, 'template', Object.assign({}, state.template, data))
  }
}

const actions = {
  fetch({ commit }, data){
    commit('fetch', data)
  },
  setTemplate({ commit }, data) {
    commit('setTemplate', data)
  }
}

const getters = {
 getTemplate: state => id => find(state.data, t => t.id.toString() === id)
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}