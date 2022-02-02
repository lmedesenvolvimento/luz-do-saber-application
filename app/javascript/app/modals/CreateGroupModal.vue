<template>
  <div class="ls-modal">
    <form class="ls-modal-form form-inline">
      <div class="ls-modal-header">
        <div v-if="isEditing" class="title">Editar Turma</div>
        <div v-else class="title">Nova Turma</div>
      </div>
      <div class="ls-modal-content">
        <div class="fields">
          <div class="form-group" :class="{ 'has-error': errors.name }">
            <label> Nome: </label>
            <span class="input">
              <input v-model="name" class="form-control" />
            </span>

            <p v-if="errors.name" class="text-danger feedback">
              Campo Obrigatório *
            </p>
          </div>
          <div class="form-group" :class="{ 'has-error': errors.description }">
            <label> Descrição: </label>
            <span class="input">
              <input v-model="description" class="form-control" />
            </span>
            <p v-if="errors.description" class="text-danger feedback">
              Campo Obrigatório *
            </p>
          </div>
        </div>
      </div>
      <div class="ls-modal-footer">
        <button
          @click="close"
          type="button"
          class="btn btn-default"
          :disabled="busy"
        >
          Cancelar
        </button>

        <button
          @click="submit"
          type="button"
          class="btn btn-primary"
          :disabled="busy"
        >
          Salvar
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import Vue from 'vue'
import { values } from 'lodash'
import objectToFormData from 'object-to-formdata'
import ActiveRecordHelper from '../utils/activerecord'

export default {
  props: {
    isEditing: {
      type: Boolean,
      default: false
    },
    groupName: {
      type: String,
      default: ''
    },
    groupDescription: {
      type: String,
      default: ''
    },
    groupId: {
      type: [Number, String],
      default: ''
    }
  },
  data() {
    return {
      errors: {},
      busy: false,
      description: '',
      name: ''
    }
  },
  computed: {
    hasError() {
      return values(this.errors).some(bool => bool)
    }
  },
  mounted() {
    if (this.isEditing) {
      this.name = this.groupName
      this.description = this.groupDescription
    }
  },
  methods: {
    async submit() {
      this.validates()

      this.busy = true

      if (this.hasError) {
        this.busy = false
        this.$notify({
          group: 'danger',
          title: 'Falha na Validação',
          text: 'Por favor verifique no formulário a causa e o motivo'
        })
        return { error: true }
      }

      const dataForm = {
        group: {
          name: this.name,
          description: this.description
        }
      }

      const formBody = objectToFormData(dataForm, { indices: true })

      try {
        const data = await this.$axios({
          url: this.isEditing ? `/groups/${this.groupId}.json` : '/groups.json',
          method: this.isEditing ? 'put' : 'post',
          data: formBody,
          headers: { 'Content-Type': 'multipart/form-data' }
        })

        if (data.errors) {
          const message = ActiveRecordHelper.errorMessage(data.errors)
          throw new Error(message)
        }

        this.$notify({
          group: 'success',
          title: 'Sucesso',
          text: this.isEditing
            ? 'Turma atualizada com sucesso!'
            : 'Nova turma criada com sucesso!'
        })

        this.$emit('close', data.data)

        return { data }
      } catch (error) {
        if (this.embedded) {
          throw new Error(error)
        } else {
          this.$notify({
            group: 'danger',
            title: 'Falha na Validação',
            text: error.message
          })
        }
        this.busy = false
        return { error: true, data: error }
      }
    },
    validates() {
      const errors = {}
      errors.name = !this.name
      errors.description = !this.description
      Vue.set(this, 'errors', errors)
    },
    close() {
      this.$emit('close', false)
    }
  }
}
</script>

<style lang="scss" scoped>
.ls-modal {
  &-content {
    padding: ($gap * 4) ($gap * 10);
    padding-bottom: $gap * 2;
  }
  &-footer {
    border-top: none;
    justify-content: center;
    padding: $gap $gap $gap * 4 $gap;
  }
}
</style>
