<template>
  <div id="templates-page">
    <div class="container-fluid">      
      <div v-if="isVisibleTemplates" class="panel panel-primary panel--box-shadow">
        <div class="panel-heading">
          <h3 class="title">
            Template de Questão
            <small class="subtitle pull-right">
              Unidade: {{ unit.title }}               
            </small>
          </h3>
        </div>
        <div class="panel-search">
          <div class="title">Template</div>
          <input placeholder="Filtrar template" v-model="query" class="form-control">
          <button class="btn btn-primary">
            <span class="icon icon-search-solid" />
          </button>
        </div>
        <div class="panel-body">
          <div class="container-fluid">
            <button @click="clear" class="btn btn-link btn-sm" title="Página Anterior">Página Anterior</button> 
            <div class="row">
              <div v-for="template in getTemplates" :key='template.id' class="col-md-4">
                <ls-item-template @imageViewer="show" :item="template"></ls-item-template>
              </div>
            </div>
          </div>          
        </div>
      </div>
      <div v-else class="panel panel-primary panel--box-shadow">
        <div class="panel-heading">
          <h3 class="title">Selecione a unidade</h3>
        </div>
        <div class="panel-body">
          <form class="form container-fluid">
            <div class="row">
              <div :class="isProfessor ? 'col-sm-4' : 'col-sm-6'">
                <div class="form-group">
                  <label>Selecione Tema: </label>
                  <ls-select-theme v-model="theme" />
                </div>
              </div>
              <div :class="isProfessor ? 'col-sm-4' : 'col-sm-6'">
                <div class="form-group">
                  <label>Selecione Unidade:</label>
                  <ls-select-unit v-model="unit" :theme="theme" />
                </div>
              </div>
              <div v-if="isProfessor" :class="isProfessor ? 'col-sm-4' : 'col-sm-6'">
                <div class="form-group">
                  <label>Selecione Grupo:</label>
                  <ls-select-group v-model="group" :groups="groups" />
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
    <viewer class="viewer" ref="viewer" @inited="inited">
      <img :src="imagePreview" class="image">
    </viewer>
  </div>
</template>

<script>
import axios from 'axios'
import { filter } from 'lodash'
import { mapState, mapActions } from 'vuex'

function isMatchTemplate(template) {
 return template.name && template.name.toUpperCase().includes(this.query.toUpperCase())
}

export default {
  data(){
    return {
      previews: [],
      query: '',
      slug: 'apresentacao-video'
    }
  },
  computed: {
    isProfessor() {
      return this.$role === 'professor'
    },
    theme: {
      get() {
        return this.template.theme
      },
      set(theme){
        this.setTemplate({ theme, unit: null })
      }
    },
    unit: {
      get() {
        return this.template.unit
      },
      set(unit){
        this.setTemplate({ unit })
      }
    },
    group: {
      get() {
        return this.template.group
      },
      set(group){
        this.setTemplate({ group })
      }
    },
    imagePreview() {
      return `/images/preview/${this.$context}/${this.slug}.png`
    },
    getTemplates() {
      if (this.query.length){
        return filter(this.templates, isMatchTemplate.bind(this))
      }
      return this.templates
    },
    isVisibleTemplates() {
      if (this.$role === 'professor') {
        return this.theme && this.unit && this.group
      }
      return this.unit
    },
    ...mapState({
      template: state => state.templates.template,
      templates: state => state.templates.data,
      groups: state => state.groups.data,
    })
  },
  methods: {
     inited (viewer) {
      this.$viewer = viewer
    },
    show(slug) {
      this.slug = slug
      this.previews = [`/images/preview/${this.$context}/${this.slug}.png`]
      this.$nextTick(() => {
        this.$viewer.show()
        console.log(this.$viewer)
      })
    },
    getUnit() {
      const urlParams = new URLSearchParams(window.location.search);
      return urlParams.get('unit_id')
    },
    clear(){
      this.unit = null
    },
    ...mapActions('templates', ['setTemplate'])
  },
  async mounted(){
    const { data } = await this.$axios.get("/themes.json");
    if (this.getUnit()) {
      data.map((el)=> {
        el.units.map((x)=> {
          if(x.id == this.getUnit()){            
            this.theme = el
            setTimeout(() => {
               this.unit = x
            }, 100);
           
          }
        })
      })
    }
    if (this.template.theme) {
      this.theme = Object.assign({}, this.template.theme)
    }
    if (this.template.unit) {
      this.unit = Object.assign({}, this.template.unit)
    }
    if (this.template.group) {
      this.group = Object.assign({}, this.template.group)
    }
  }
}
</script>

<style scoped lang="scss">
#templates-page{
  padding: 48px 0px;
  .image {
   display: none;
  }
  .panel{
    &-heading{
      text-align: left;
      .title{ 
        margin: 8px 36px;
      }
      .subtitle{
        line-height: 24px;
        color: #eee;
      }
    }
    &-search{
      display: flex;
      align-items: center;
      justify-content: space-evenly;
      background-color: #eee;
      width: 100%;
      height: 88px;
      input {
        max-width: 70%;
      }
      .title{
        font-weight: bold;
      }
    }
  }
  @media (max-width: 768px) { 
    .panel{
      &-search {
        input {
          max-width: 50%;
        }
      }
    }
  }
}

</style>