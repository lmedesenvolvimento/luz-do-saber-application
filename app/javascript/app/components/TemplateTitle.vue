<template>
  <div id="template-title" class="template-title container-fluid">
    <div class="row">
      <div class="col-md-7">
        <div class="template-title-input-group form-group">
          <div class="label">Título: </div>
          <input
            v-model="template.question_title" 
            placeholder="Informe o título do template" 
            class="form-control"
            disabled
          />
        </div>
      </div>
      <div class="col-md-5"></div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    template: {
      type: Object,
      default: {}
    }
  }
}
</script>

<style lang="scss">
.template-title{
  @include template-editor-field;
}
</style>