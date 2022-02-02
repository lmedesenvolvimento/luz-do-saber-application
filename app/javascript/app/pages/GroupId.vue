<template>
  <div id="group-id-page">
    <div class="container-fluid">
      <div class="panel panel-primary panel--box-shadow">
        <div class="panel-heading">
          <router-link
            tag="button"
            class="btn-circle btn-circle--transparent"
            to="/groups"
          >
            <i class="fa fa-arrow-left"></i
          ></router-link>
          <h3 class="title">
            {{ group.name }}
          </h3>
          <div class="dropdown-ellipsis">
            <button
              class="btn-circle btn-circle--transparent"
              @click="toogleMenu"
            >
              <i class="fa fa-ellipsis-v"></i>
            </button>
            <div class="dropdown-items" v-show="isVisibleMenu">
              <div class="d-item" @click="openEditGroup">Editar Turma</div>
              <div class="d-item" @click="deleteGroup">Excluir Turma</div>
            </div>
          </div>
        </div>
        <div class="panel-body">
          <div class="container-fluid">
            <div class="panel-info-container">
              <div class="panel-info colored">
                <div class="item-info">
                  <div class="name">NOME</div>
                  <div class="value">{{ group.name }}</div>
                </div>
                <div class="item-info">
                  <div class="name">CÓDIGO</div>
                  <div class="value">{{ group.code }}</div>
                </div>
                <div class="item-info">
                  <div class="name">AUTOR</div>
                  <div class="value">{{ fullAuthorName }}</div>
                </div>
                <div class="item-info">
                  <div class="name">DESCRIÇÃO</div>
                  <div class="value black-color">{{ group.description }}</div>
                </div>
              </div>
            </div>
            <ls-tabs margin="-33" @change="changeTabs">
              <ls-tab :title="`Alunos  (${getStudents.length})`">
                <div v-if="showStudents">
                  <span v-if="!isVisibleStudentInfo">
                    <div class="panel-search">
                      <input
                        placeholder="Buscar Aluno"
                        class="form-control"
                        v-model="searchStudents"
                      />
                      <button class="btn btn-primary size-85">
                        <span class="icon icon-search-solid" />
                      </button>
                      <button
                        class="btn btn-primary float-right text"
                        @click="openCreateStudent"
                      >
                        <i class="fa fa-plus"></i>
                        <span>Adicionar aluno</span>
                      </button>
                    </div>
                    <table class="t-table-striped table-colored">
                      <tr>
                        <th>Nome</th>
                        <th>Último Login</th>
                        <th>Sessão</th>
                        <th class="table-action">Ações</th>
                      </tr>
                      <tr
                        v-for="student in getStudentsFiltered"
                        :key="student.user_id"
                      >
                        <td class="text-capitalize">
                          <span class="table-id">{{ student.id }}. </span>
                          {{ `${student.first_name} ${student.last_name}` }}
                        </td>
                        <td>{{ formatDataBR(student.updated_at) }}</td>
                        <td></td>
                        <td>
                          <button
                            class="btn-circle btn-circle--icon"
                            @click="openStudent(student)"
                          >
                            <i class="fa fa-eye"></i>
                          </button>
                          <button
                            class="btn-circle btn-circle--icon"
                            @click="openCreateStudent(student)"
                          >
                            <i class="fa fa-edit"></i>
                          </button>
                          <button
                            class="btn-circle btn-circle--icon"
                            @click="deleteParticipant(student)"
                          >
                            <i class="fa fa-trash"></i>
                          </button>
                        </td>
                      </tr>
                    </table>
                  </span>
                  <ls-user-info
                    v-else
                    class="info-user-component"
                    @close="closeStudent"
                    :user="currentStudent"
                    embeded
                  ></ls-user-info>
                </div>
                <div v-else class="empty-registry">
                  <span>Nenhum aluno adicionado a turma.</span>
                  <button
                    class="btn btn-primary text"
                    @click="openCreateStudent"
                  >
                    <i class="fa fa-plus"></i>
                    <span>Adicionar aluno</span>
                  </button>
                </div>
              </ls-tab>
              <ls-tab :title="`Professores  (${getTeachers.length})`">
                <div v-if="showTeachers">
                  <span v-if="!isVisibleTeacherInfo">
                    <div class="panel-search">
                      <input
                        placeholder="Buscar Professor"
                        class="form-control"
                        v-model="searchTeachers"
                      />
                      <button class="btn btn-primary size-85">
                        <span class="icon icon-search-solid" />
                      </button>
                      <button
                        class="btn btn-primary float-right text"
                        @click="openCreateTeacher"
                      >
                        <i class="fa fa-plus"></i>
                        <span>Adicionar professor</span>
                      </button>
                    </div>
                    <table class="t-table-striped table-colored">
                      <tr>
                        <th>Nome</th>
                        <th>Último Login</th>
                        <th>Status</th>
                        <th class="table-action">Ações</th>
                      </tr>
                      <tr
                        v-for="teachers in getTeachersFiltered"
                        :key="teachers.user_id"
                      >
                        <td class="text-capitalize">
                          <span class="table-id">{{ teachers.id }}. </span>
                          {{ `${teachers.first_name} ${teachers.last_name}` }}
                          {{ isAuthor(teachers) }}
                        </td>
                        <td>{{ formatDataBR(teachers.updated_at) }}</td>
                        <td>{{ getStatus(teachers.status_ingroup) }}</td>
                        <td>
                          <button
                            class="btn-circle btn-circle--icon"
                            @click="openTeacher(teachers)"
                          >
                            <i class="fa fa-eye"></i>
                          </button>
                          <button
                            class="btn-circle btn-circle--icon"
                            @click="openCreateTeacher(teachers)"
                          >
                            <i class="fa fa-edit"></i>
                          </button>
                          <button
                            class="btn-circle btn-circle--icon"
                            @click="deleteParticipant(teachers)"
                          >
                            <i class="fa fa-trash"></i>
                          </button>
                        </td>
                      </tr>
                    </table>
                  </span>
                  <ls-user-info
                    v-else
                    class="info-user-component"
                    @close="closeTeacher"
                    :user="currentTeacher"
                    embeded
                  ></ls-user-info>
                </div>
                <div v-else class="empty-registry">
                  <span>Nenhum professor adicionado a turma.</span>
                  <button
                    class="btn btn-primary text"
                    @click="openCreateTeacher"
                  >
                    <i class="fa fa-plus"></i>
                    <span>Adicionar Professor</span>
                  </button>
                </div>
              </ls-tab>
            </ls-tabs>
          </div>
        </div>
      </div>
    </div>
    <modal :name="modalId" height="auto">
      <ls-modal-create-participant
        @close="closeCreateParticipant"
        :group-id="groupId"
        :type-participant="currentTypeUser"
        :is-editing="isEditingParticipant"
        :participant="currentParticipantEdit"
      ></ls-modal-create-participant>
    </modal>
    <modal :name="modalEditId" height="auto">
      <ls-modal-create-group
        @close="closeEditGroup"
        :group-name="group.name"
        :group-description="group.description"
        :group-id="groupId"
        isEditing
      />
    </modal>
  </div>
</template>

<script>
import { filter } from 'lodash'
import { formatDataBR } from '../utils/utils'
import shortid from 'shortid'

export default {
  data() {
    return {
      participants: [],
      searchStudents: '',
      searchTeachers: '',
      currentStudent: [],
      currentTeacher: [],
      isVisibleStudentInfo: false,
      isVisibleTeacherInfo: false,
      isVisibleMenu: false,
      currentTypeUser: 'student',
      modalId: shortid.generate(),
      modalEditId: shortid.generate(),
      isEditingParticipant: false,
      currentParticipantEdit: {},
      formatDataBR
    }
  },
  async created() {
    try {
      const { id } = this.$route.params
      const { data } = await this.$axios(`/groups/${id}/participants.json`)
      this.participants = data.map(el => {
        return {
          type: el.type,
          status_ingroup: el.status,
          id_ingroup: el.id,
          ...el.user
        }
      })
    } catch (e) {
      this.errorMessage = e.toString()
    } finally {
    }
  },
  mounted() {},
  computed: {
    group() {
      const { id } = this.$route.params
      return this.$store.getters['groups/getGroup'](id) || {}
    },
    groupId() {
      const { id } = this.$route.params
      return id
    },
    fullAuthorName() {
      if (this.group.user)
        return `${this.group.user.first_name} ${
          this.group.user.last_name ? this.group.user.last_name : ''
        }`
      else return ''
    },
    getStudents() {
      return filter(this.participants, { type: 'student' })
    },
    getTeachers() {
      return filter(this.participants, { type: 'professor' })
    },
    getStudentsFiltered() {
      if (this.searchStudents.length) {
        return filter(this.getStudents, this.isMatchStudents.bind(this))
      }
      return this.getStudents
    },
    getTeachersFiltered() {
      if (this.searchTeachers.length) {
        return filter(this.getTeachers, this.isMatchTeachers.bind(this))
      }
      return this.getTeachers
    },
    showStudents() {
      return this.getStudents.length > 0
    },
    showTeachers() {
      return this.getTeachers.length > 0
    }
  },
  methods: {
    getStatus(n) {
      if (n === 'active') return 'Ativo'
      else return 'Inativo'
    },
    toogleMenu() {
      this.isVisibleMenu = !this.isVisibleMenu
    },
    openStudent(u) {
      this.currentStudent = this.mapUser(u)
      this.isVisibleStudentInfo = true
    },
    closeStudent() {
      this.isVisibleStudentInfo = false
    },
    openTeacher(u) {
      this.currentTeacher = this.mapUser(u)
      this.isVisibleTeacherInfo = true
    },
    closeTeacher() {
      this.isVisibleTeacherInfo = false
    },
    isMatchStudents(group) {
      const fullName = `${group.first_name} ${group.last_name}`
      return (
        group.first_name &&
        fullName.toUpperCase().includes(this.searchStudents.toUpperCase())
      )
    },
    isMatchTeachers(group) {
      const fullName = `${group.first_name} ${group.last_name}`
      return (
        group.first_name &&
        fullName.toUpperCase().includes(this.searchTeachers.toUpperCase())
      )
    },
    isAuthor(i) {
      if (this.group.user && this.group.user.id === i.id) return ' (Autor)'
      else return ''
    },
    changeTabs() {
      this.isVisibleTeacherInfo = false
      this.isVisibleStudentInfo = false
    },
    async refreshGroupsParticipants() {
      const { data } = await this.$axios(
        `/groups/${this.groupId}/participants.json`
      )
      this.participants = data.map(el => {
        return {
          type: el.type,
          status_ingroup: el.status,
          id_ingroup: el.id,
          ...el.user
        }
      })
    },
    async refreshGroups() {
      const groups = await this.$axios.get('/groups.json')
      this.$store.dispatch('groups/fetch', groups.data)
    },
    closeCreateParticipant(data) {
      if (data) this.refreshGroupsParticipants()
      this.$modal.hide(this.modalId)
    },
    closeEditGroup(data) {
      if (data) {
        this.refreshGroups()
      }
      this.$modal.hide(this.modalEditId)
    },
    openEditGroup() {
      this.toogleMenu()
      this.$modal.show(this.modalEditId)
    },
    openCreateStudent(edit) {
      if (edit.email) {
        this.isEditingParticipant = true
        this.currentParticipantEdit = edit
      } else this.isEditingParticipant = false

      this.currentTypeUser = 'student'
      this.$modal.show(this.modalId)
    },
    openCreateTeacher(edit) {
      if (edit.email) {
        this.isEditingParticipant = true
        this.currentParticipantEdit = edit
      } else this.isEditingParticipant = false
      this.currentTypeUser = 'professor'
      this.$modal.show(this.modalId)
    },
    mapUser(u) {
      const user = {}
      if (u.game) user.game = u.game
      user.type = u.role
      user.user = u
      user.user.name = `${u.first_name} ${u.last_name}`
      return user
    },
    deleteParticipant(p) {
      this.$confirm('Tem certeza que deseja excluir?')
        .then(() => {
          this.submitDeleteParticipant(p.id_ingroup)
        })
        .catch(() => {
          return null
        })
    },
    deleteGroup() {
      this.$confirm('Tem certeza que deseja excluir?')
        .then(() => {
          this.submitDeleteGroup()
        })
        .catch(() => {
          return null
        })
    },
    async submitDeleteParticipant(id) {
      try {
        const data = await this.$axios({
          url: `/groups/${this.groupId}/participants/${id}.json`,
          method: 'delete',
          headers: { 'Content-Type': 'multipart/form-data' }
        })

        if (data.errors) {
          const message = ActiveRecordHelper.errorMessage(data.errors)
          throw new Error(message)
        }

        this.$notify({
          group: 'success',
          title: 'Sucesso',
          text: 'Participante excluido com sucesso!'
        })
        this.refreshGroupsParticipants()
      } catch (error) {
        this.$notify({
          group: 'danger',
          title: 'Falha na Validação',
          text: error.message
        })
      }
    },
    async submitDeleteGroup() {
      try {
        const data = await this.$axios({
          url: `/groups/${this.groupId}.json`,
          method: 'delete',
          headers: { 'Content-Type': 'multipart/form-data' }
        })

        if (data.errors) {
          const message = ActiveRecordHelper.errorMessage(data.errors)
          throw new Error(message)
        }

        this.$notify({
          group: 'success',
          title: 'Sucesso',
          text: 'Turma excluida com sucesso!'
        })
        this.refreshGroups()
        this.refreshGroupsParticipants()
        this.$router.replace('/')
      } catch (error) {
        this.$notify({
          group: 'danger',
          title: 'Falha na Validação',
          text: error.message
        })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
#group-id-page {
  padding: 48px 0px;
  min-width: 1040px;
  .panel {
    &-heading {
      text-align: left;
      box-shadow: 0px 3px 6px #00000029;
      display: flex;
      align-items: center;
      .title {
        margin: 8px 22px;
        min-height: 26.4px;
        text-transform: uppercase;
      }

      .dropdown-ellipsis {
        margin-left: auto;
        position: relative;

        .dropdown-items {
          position: absolute;
          min-width: 180px;
          min-height: 50px;
          background-color: white;
          border-radius: $border-radius;
          box-shadow: $box-shadown;
          right: 0;
          display: flex;
          flex-direction: column;
          padding: $gap;
          row-gap: $gap;

          .d-item {
            padding: $gap $gap * 2;
            color: $txt-color;
            font-size: 14px;
            border-radius: $border-radius;
            &:hover {
              background-color: $grey-light-2;
              cursor: pointer;
            }
          }
        }
      }
    }

    &-body {
      padding: 20px 33px;
      min-height: 500px;

      .container-fluid {
        padding: 0;
      }
    }
    &-info {
      margin: $gap 0 $gap * 4 0;
      column-gap: 40px;
      row-gap: 30px;

      .item-info {
        min-width: 180px;
        max-width: 250px;

        .black-color {
          color: $text-color;
          text-transform: initial;
        }
      }
    }

    &-search {
      padding: $gap * 3 0 0 0;
      height: initial;
      input {
        max-width: 40%;
      }
      .size-85 {
        width: 85px;
      }
      .float-right {
        position: absolute;
        right: 0;
      }
    }
  }

  .empty-registry {
    @include flex-center;
    flex-direction: column;
    width: 100%;
    height: 250px;
    span {
      margin-bottom: $gap * 2;
    }
  }

  .t-table-striped {
    margin-top: $gap * 2;
  }

  .info-user-component {
    margin-top: $gap * 3;
  }
}
</style>
