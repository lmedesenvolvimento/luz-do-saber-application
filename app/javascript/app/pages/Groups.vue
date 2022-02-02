<template>
  <div id="groups-page">
    <div class="container-fluid">
      <div class="panel panel-primary panel--box-shadow">
        <div class="panel-heading">
          <h3 class="title">
            Turmas
          </h3>
        </div>
        <div class="panel-search">
          <div class="title">Nome:</div>
          <input
            placeholder="Filtrar Turmas"
            class="form-control"
            v-model="query"
          />
          <button class="btn btn-primary">
            <span class="icon icon-search-solid" />
          </button>
        </div>
        <div class="panel-body">
          <div class="container-fluid">
            <div class="filter-section"></div>
            <div class="content-section">
              <div class="card card--dashed" @click="openCreateGroup">
                <button class="btn-circle btn-circle--secondary large">
                  <i class="fa fa-plus"></i>
                </button>
                <span>Criar turma</span>
              </div>
              <div
                v-for="group in getGroups"
                :key="group.code"
                class="card card--primary"
                @click="showGroup(group)"
              >
                <div class="card-top-container">
                  <div class="c-name">Nome</div>
                  <div class="c-name-content">{{ group.name }}</div>
                </div>
                <div class="card-bottom-container">
                  <span>
                    <div class="c-item-name">Código</div>
                    <div class="c-item-content">{{ group.code }}</div></span
                  >
                  <span>
                    <div class="c-item-name">Alunos</div>
                    <div class="c-item-content">
                      {{ getStudents(group.participants).length }}
                    </div></span
                  >
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <modal :name="modalId" height="auto">
      <ls-modal-create-group @close="closeCreateGroup" />
    </modal>
  </div>
</template>

<script>
import shortid from 'shortid'
import { filter } from 'lodash'

function isMatchGroup(group) {
  return (
    group.name && group.name.toUpperCase().includes(this.query.toUpperCase())
  )
}

export default {
  data() {
    return {
      loading: true,
      query: '',
      modalId: shortid.generate()
    }
  },
  computed: {
    groups() {
      return this.$store.state.groups.data
    },
    getGroups() {
      if (this.query.length) {
        return filter(this.groups, isMatchGroup.bind(this))
      }
      return this.groups
    }
  },
  async created() {},
  methods: {
    showGroup(group) {
      this.$router.replace({
        path: `/group/${group.id}/`
      })
    },
    getStudents(participants) {
      if (!participants) return []
      return participants.filter(({ type }) => {
        return type === 'student'
      })
    },
    openCreateGroup() {
      this.$modal.show(this.modalId)
    },
    async refreshGroups() {
      const groups = await this.$axios.get('/groups.json')
      this.$store.dispatch('groups/fetch', groups.data)
    },
    closeCreateGroup(data) {
      if (data) {
        this.refreshGroups()
      }
      this.$modal.hide(this.modalId)
    }
  }
}
</script>

<style scoped lang="scss">
#groups-page {
  padding: 48px 0px;
  .panel {
    &-heading {
      text-align: left;
      box-shadow: 0px 3px 6px #00000029;
      .title {
        margin: 8px 22px;
        text-transform: uppercase;
      }
      .subtitle {
        line-height: 24px;
        color: #eee;
      }
    }
    &-search {
      margin-top: $gap * 2;

      .btn {
        width: 85px;
      }
    }
    &-body {
      padding: 20px 33px 50px 33px;
      min-height: 500px;

      .container-fluid {
        padding: 0;
      }

      .content-section {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: $gap * 3;

        .card {
          width: 100%;
        }
      }
    }
  }

  .card {
    min-width: 175px;
    min-height: 144px;

    &--dashed {
      .btn-circle {
        @include flex-center;
        font-size: 20px;
      }

      span {
        text-transform: uppercase;
        color: $brand-primary;
        margin-top: $gap;
        font-weight: 600;
      }
    }
    &-top-container {
      color: white;
      font-weight: 600;
      min-height: 80px;
      .c-name {
        font-size: 12px;
      }
      .c-name-content {
        text-transform: uppercase;
        text-align: center;
      }
    }
    &-bottom-container {
      display: flex;
      align-items: center;
      justify-content: space-evenly;
      height: 64px;

      span {
        min-width: 60px;
        text-align: center;
        font-size: 12px;
        .c-item-name {
          color: $txt-color-light;
        }
        .c-item-content {
          font-weight: 600;
          color: $brand-primary;
        }
      }
    }
  }
}
</style>
