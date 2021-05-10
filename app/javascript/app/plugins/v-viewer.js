import 'viewerjs/src/css/viewer.scss'
import Viewer from 'v-viewer'
import Vue from 'vue'

Vue.use(Viewer)

Viewer.setDefaults({
  "button": true, 
  "navbar": false, 
  "title": false, 
  "toolbar": false, 
  "tooltip": false, 
  "movable": false, 
  "zoomable": true,
  "rotatable": false, 
  "scalable": false, 
  "fullscreen": false, 
  "keyboard": false, 
})