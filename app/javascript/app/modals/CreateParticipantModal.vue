<template>
  <div class="ls-modal">
    <form class="ls-modal-form form-inline">
      <div class="ls-modal-header">
        <div v-if="isEditing" class="title">Editar {{ getType }}</div>
        <div v-else class="title">Novo {{ getType }}</div>
      </div>
      <div class="ls-modal-content">
        <div class="fields">
          <div class="form-group">
            <label>Status: </label>
            <span class="input">
              <v-select
                :value="status"
                :filterable="false"
                :clearable="false"
                :options="statusOptions"
                placeholder="Selecionar"
                @input="onChangeStatus"
              >
              </v-select>
            </span>
          </div>
          <div class="form-group" :class="{ 'has-error': errors.email }">
            <label> Código: </label>
            <span class="input">
              <input v-model="school_student_code" class="form-control" />
            </span>

            <p v-if="errors.school_student_code" class="text-danger feedback">
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
    typeParticipant: {
      type: String,
      default: 'student'
    },
    groupId: {
      type: [Number, String],
      required: true
    },
    participant: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      errors: {},
      busy: false,
      school_student_code: '',
      participantId: 0,
      status: { label: 'Ativo', value: 'active' },
      statusOptions: [
        { label: 'Ativo', value: 'active' },
        { label: 'Inativo', value: 'inactive' }
      ]
    }
  },
  computed: {
    hasError() {
      return values(this.errors).some(bool => bool)
    },
    getType() {
      if (this.typeParticipant === 'student') return 'aluno'
      else return 'professor'
    }
  },
  created() {},
  mounted() {
    if (this.isEditing) {
      this.school_student_code = this.participant.school_student_code
      this.participantId = this.participant.id_ingroup
      if (this.participant.status_ingroup === 'inactive') {
        this.status = { label: 'Inativo', value: 'inactive' }
      }
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
        groups_participant: {
          type: this.typeParticipant,
          user_school_student_code: this.school_student_code,
          status: this.status.value
        }
      }

      const formBody = objectToFormData(dataForm, { indices: true })

      try {

        const data = await this.$axios({
          url: this.isEditing
            ? `/groups/${this.groupId}/participants/${this.participantId}.json`
            : `/groups/${this.groupId}/participants.json`,
          method: this.isEditing ? 'put' : 'post',
          data: formBody,
          headers: { 'Content-Type': 'multipart/form-data' }
        })

        if (data.errors) {
          const message = ActiveRecordHelper.errorMessage(data.errors)
          throw new Error(message)
        }

        if (data.data.errors && data.data.errors.user_school_student_code) {
          const message = ActiveRecordHelper.errorMessage(
            data.data.errors.user_school_student_code
          )
          throw new Error(message)
        }

        this.$notify({
          group: 'success',
          title: 'Sucesso',
          text: this.isEditing
            ? 'Participante atualizado com sucesso!'
            : 'Novo participante criado com sucesso!'
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
    onChangeStatus(status) {
      this.status = status
    },
    validates() {
      const errors = {}
      errors.school_student_code = !this.school_student_code
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
