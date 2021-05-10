<template>
    <div class="item-template container-fluid">
      <div class="row item-template-body">
        <div class="col-xs-12">
          <div class="title" :alt="item.name">{{ item.name }}</div>
          <div class="description" :alt="description">
            {{ description }}
          </div>
        </div>
      </div>
      <div class="item-template-actions">
        <button class="btn btn-sm btn-default" @click="show">Preview</button>
        <router-link 
          tag="a" 
          class="btn btn-sm btn-primary" 
          :to="{ path: newTemplateURL }"
        >
          Criar Template
        </router-link>
      </div>       
    </div>
</template>

<script>
import { mapState } from 'vuex'
export default {
  props: {
    item: {}
  },
  computed: {
    imagePreview() {
      return `/images/preview/${this.$context}/${this.item.slug}.png`
    },
    description() {
      if (this.item.question_description) {
        return this.item.question_description
      }
      return 'Sem descrição'.toUpperCase()
    },
    newTemplateURL() {
      const url = [
        'new-template',
        'tema',
        this.theme_id,
        'unidade',
        this.unit_id,
        'template',
        this.item.id,
        this.item.slug
      ]
      if (this.$role === 'professor') {
        return url.join('/') + `?group_id=${this.group_id}`
      }
      return url.join('/')
    },
    ...mapState({
      group_id: ({ templates }) => templates.template.group.id,
      unit_id: ({ templates }) => templates.template.unit.id,
      theme_id: ({ templates }) => templates.template.theme.id
    })
  },
  methods: {
    show() {
     this.$emit('imageViewer', this.item.slug)
    }
  }
}
</script>

<style scoped lang="scss">
.item-template {
  display: flex;
  flex-direction: column;
  height: 118px !important;
  margin: #{$gap * 2} auto;
  .none {
    display: none;
  }
  .image {
   display: none;
  }
  .title{
    font-size: 16px;
    font-weight: bold;
    margin: $gap 0px ( $gap / 2 );
    line-height: 1.1;
    text-transform: uppercase;
  }
  .description {    
    font-size: 13px;
    line-height: 1.1;
    color: transparentize($text-color, 0.4);
    overflow: hidden;
  }
  > .row {
    display: flex;
    flex-wrap: wrap;
  }
  &-placeholder{
    display: flex;
    height: 44px;
    width: 100%;
    margin: 8px auto;
    background-color: #eee;
    justify-content: center;
    align-items: center;
    .icon {
      color: #ccc;
    }
  }
  &-body{
    flex: 1;
    padding: 4px 0px;
  }
  &-actions {
    display: flex;
    align-items: center;
    flex: 1;
    max-height: ($gap * 5);
    margin: 0px;
    .btn {
      font-size: 14px;
    }
    .btn:first-child{
      margin-right: $gap;
    }
    .btn-default {
      border-color: $brand-primary;
      color: $brand-primary;
    }
  }
}
</style>