<template>
  <div class="wordtype--radio-button container-fluid">
    <div class="row"><div class="col-md-7">
        <div class="form-group wordtype--radio-button-input-group">
          <div class="label">Tipo: </div>
          <div class="checkbox-group">
            <div v-for="t in types" :key="t.key" class="checkbox-inline">
              <label :for="t.key">{{ t.label }}</label>
              <input 
                type="radio" 
                :id="t.key" 
                :value="t.value" 
                :name="group"
                :checked="t.value === input"
                @change="() => $emit('change', t.value)"
              >
            </div>
            <div class="checkbox-inline extra-input">
              <slot name="extra-input" />
            </div>
          </div>
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
    input: null,
    types: {
      type: Array,
      default: []
    },
    group: {
      type: String,
      default: ''
    }
  },  
}
</script>

<style lang="scss" scoped>
.wordtype {
  &--radio-button{
    @include template-editor-field;
    .checkbox-group{
      display: flex;
      flex: 3;
      .checkbox-inline {
        display: inline-flex;
        align-items: center;
        &.extra-input{
          display: block;
          margin-left: auto;
          width: 100%;
        }
        &:first-child{
          padding-left: 0px;
        }
        label {
          margin-bottom: 0px;
          margin-right: $gap;
        }
        input {
          margin: 0px;
        }
        .v-select {
          width: 100%;
        }
      }
    }
  }
}
</style>