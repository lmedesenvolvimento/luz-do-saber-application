import Vue from 'vue'
import VueSimpleAlert from 'vue-simple-alert'

Vue.use(VueSimpleAlert, {
  reverseButtons: true,
  buttonsStyling: false,
  cancelButtonText: 'Cancelar',
  customClass: {
    confirmButton: 'btn btn-primary',
    denyButton: 'btn btn-default',
    cancelButton: 'btn btn-default'
  }
})
