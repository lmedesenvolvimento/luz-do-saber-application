<template>
    <div class="input-file">
      <div class="input-group">
        <div class="input-group-addon">
          <button class="file-btn btn btn-xs" :class="{'btn-danger': invalid, 'btn-default': !invalid}">
            <slot />
            <input 
              ref="file"
              type="file"
              :accept="accept"
              @change="handleFileUpload"
            />
          </button>
        </div>
        <input
            :value="input ? input.name : placeholder"
            class="form-control"
            disabled
        />
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
    accept: null,
    input: null,
    btnText: '',
    invalid: {
      type: Boolean,
      default: false
    },
    placeholder: '',
    isEditing: {
      type: Boolean,
      default: false
    },
    isNotEmpty: {
      type: Boolean,
      default: false
    }
  },  
  methods: {
    handleFileUpload(){
      const file = this.$refs.file.files[0]
      this.$emit('change', file)
    }
  },
}
</script>

<style lang="scss" scoped>
.input-file{
  flex: 3;
  max-width: 75%;
  .input-group{
    .input-group-addon{
      background-color: transparent;
      padding: 0px;
      border: none;
      .btn {
        padding: 7px ($gap * 3);
        background-color: transparent;
        border-top-right-radius: 0px;
        border-bottom-right-radius: 0px;
        &.btn-default {
          border: 1px solid $brand-primary;
          color: $brand-primary;
        }
        &.btn-danger {
          border: 1px solid $brand-danger;
          color: $brand-danger;
        }
      }
    }
    .file-btn{
      input {
        position: absolute;
        font-size: 24px;
        opacity: 0;
        right: 0;
        top: 0;
      }
    }
  }
}
</style>
