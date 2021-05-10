import VueRouter from 'vue-router'

import Templates from '../pages/Templates'
import NewTemplate from '../pages/NewTemplate'
import EditTemplate from '../pages/EditTemplate.vue'

import templates from './templates'

const routes = [
  { name: 'templates', path: '/', component: Templates },
  { 
    name: 'new-template', 
    path: '/new-template/tema/:theme_id/unidade/:unit_id/template/:id', 
    component: NewTemplate,
    children: templates
  },
  { 
    name: 'edit-template', 
    path: '/edit-template/:id', 
    component: EditTemplate,
    children: templates
  },
]

const router = new VueRouter({
  routes // short for `routes: routes`
})

export default router;
