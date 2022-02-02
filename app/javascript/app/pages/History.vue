<template>
  <div id="history-page">
    <div class="container-fluid">
      <div class="panel panel-primary panel--box-shadow">
        <div class="panel-heading">
          <h3 class="title">
            Histórico
          </h3>
        </div>
        <div class="panel-body">
          <div v-if="loading" class="loading-content">
            <div class="lds-ring">
              <div></div>
              <div></div>
              <div></div>
              <div></div>
            </div>
          </div>
          <div v-else class="container-fluid">
            <transition name="fade" mode="out-in">
              <table v-if="!isVisibleUser" class="t-table-striped">
                <tr>
                  <th>Estudante</th>
                  <th>Sessão</th>
                  <th>Criação</th>
                  <th class="table-action"></th>
                </tr>
                <tr v-for="h in history" :key="h.unique_session_id">
                  <td>
                    <span class="table-id">{{ h.id }}. </span>
                    {{ h.name }}
                  </td>
                  <td>{{ h.unique_session_id }}</td>
                  <td>{{ formatDataBR(h.created_at) }}</td>
                  <td>
                    <button
                      class="btn-circle btn-circle--primary"
                      @click="openUser(h)"
                    >
                      <i class="fa fa-arrow-right"></i>
                    </button>
                  </td>
                </tr>
              </table>

              <ls-user-info
                v-else
                @close="closeUser"
                :user="currentHistory"
              ></ls-user-info>
            </transition>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isVisibleUser: false,
      history: [],
      currentHistory: [],
      loading: true
    }
  },
  async created() {
    try {
      const { data } = await this.$axios('/user_games.json')
      this.history = data
    } catch (e) {
      this.errorMessage = e.toString()
    } finally {
      this.loading = false
    }
  },
  methods: {
    openUser(h) {
      this.currentHistory = this.mapUser(h)
      this.isVisibleUser = true
    },
    closeUser() {
      this.isVisibleUser = false
    },
    formatDataBR(data) {
      let dataAtual = new Date(data)
      let dataFormated =
        this.addZero(dataAtual.getDate().toString()) +
        '/' +
        this.addZero(dataAtual.getMonth() + 1).toString() +
        '/' +
        dataAtual.getFullYear()
      return dataFormated
    },
    addZero(n) {
      if (n <= 9) return '0' + n
      else return n
    },
    mapUser(u) {
      const user = {}
      user.game = u.game
      user.type = 'student'
      user.user = {}
      user.user.created_at = u.created_at
      user.user.id = u.id
      user.user.name = u.name
      user.user.unique_session_id = u.unique_session_id
      return user
    }
  }
}
</script>

<style scoped lang="scss">
#history-page {
  padding: 48px 0px;
  min-width: 1060px;

  .panel {
    &-heading {
      text-align: left;
      box-shadow: 0px 3px 6px #00000029;
      .title {
        margin: 8px 36px;
      }
      .subtitle {
        line-height: 24px;
        color: #eee;
      }
    }
    &-body {
      padding: 29px 33px;
      min-height: 500px;

      .loading-content {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 400px;

        .lds-ring {
          @include lds-ring-loading;
          transform: scale(0.8);
        }
      }
    }
  }

  .fade-leave-active {
    transition: all 0.3s ease;
    opacity: 0;
  }
}
</style>
