<template>
  <div id="template-order" class="template-order container-fluid">
    <div class="row">
      <div class="col-md-7">
        <div class="template-order-input-group form-group">
          <div class="label">Ordem: </div>
          <input
            :value="input"
            type="number"
            placeholder="Informe a ordem da atividade" 
            class="form-control"
            @input="updateOrder"
          />
        </div>
      </div>
      <div class="col-md-5"></div>
    </div>
  </div>
</template>

<script>
export default {
  model: {
    prop: 'input',
    event: 'change'
  },
  props: {
    input: null
  },
  methods: {
    updateOrder(event){
      this.$emit('change', event.target.value)
    }
  }
}
</script>

<style lang="scss" scoped>
.template-order{
  @include template-editor-field;
}
</style>