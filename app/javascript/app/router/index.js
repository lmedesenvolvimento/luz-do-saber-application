import VueRouter from 'vue-router'

import Templates from '../pages/Templates'
import NewTemplate from '../pages/NewTemplate'
import EditTemplate from '../pages/EditTemplate.vue'
import History from '../pages/History.vue'
import Groups from '../pages/Groups.vue'
import GroupId from '../pages/GroupId.vue'

import templates from './templates'

const root = {
  name: 'templates',
  path: '/',
  component: Templates
}

function getRoot() {
  const path = window.location.href

  if (path.includes('user_games')) {
    root.name = 'history'
    root.component = History
  } else if (path.includes('groups')) {
    root.name = 'groups'
    root.component = Groups
  }
  return root
}


const routes = [
  getRoot(),
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
  {
    name: 'groups',
    path: '/groups',
    component: Groups
  },
  {
    name: 'group-id',
    path: '/group/:id',
    component: GroupId
  }
]

const router = new VueRouter({
  routes // short for `routes: routes`
})

export default router
