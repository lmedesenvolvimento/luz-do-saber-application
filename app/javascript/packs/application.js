/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.
import Vue from 'vue'

import '../app/assets/styles/application.scss'

import '../app/plugins/vue-router'
import '../app/plugins/vuex'
import '../app/plugins/plyr'
import '../app/plugins/notification'
import '../app/plugins/vue-js-modal'
import '../app/plugins/v-viewer'
import $axios from '../app/plugins/axios'

import router from '../app/router'
import store from '../app/store'

import '../app/components'
import App from '../app/components/App.vue'

const context = document.querySelector('meta[name=context]')
const user_session = document.querySelector('meta[name=user-role]')

Vue.prototype.$axios = $axios
Vue.prototype.$role = user_session.getAttribute('content')
Vue.prototype.$context = context.getAttribute('content')

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#app_vue',
    store,
    router,
    render: h => h(App)    
  }).$mount()
})


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
//
//
//
// If the project is using turbolinks, install 'vue-turbolinks':
//
// yarn add vue-turbolinks
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: () => {
//       return {
//         message: "Can you say hello?"
//       }
//     },
//     components: { App }
//   })
// })
