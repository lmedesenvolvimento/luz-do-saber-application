<template>
  <div id="history-user" ref="historyUser">
    <div class="back-button" @click="close">
      <i class="fa fa-arrow-left"></i> VOLTAR
    </div>
    <div class="panel-info-container">
      <div v-if="embeded" class="info-title">
        Informações do {{ getTypeName }}
      </div>
      <div class="panel-info" :class="{ colored: !embeded }">
        <div v-if="embeded" class="info-subtitle">
          {{ userInfos.id }}. {{ userInfos.name }}
        </div>
        <div v-if="!embeded" class="item-info">
          <div class="name">Estudante</div>
          <div class="value">{{ userInfos.id }}. {{ userInfos.name }}</div>
        </div>
        <div
          v-for="(info, index) in userInfosFormated"
          :key="index"
          class="item-info"
        >
          <div class="name">{{ info.name }}</div>
          <div class="value">{{ info.value }}</div>
        </div>
      </div>
    </div>
    <ls-tabs ref="tabs" v-if="isStudent" v-bind="tabStyle" :key="relatorioKey">
      <ls-tab title="Temas">
        <table class="t-table-light">
          <tr>
            <th>Nome</th>
            <th class="w100">Concluída</th>
          </tr>
          <tr v-for="theme in userThemes" :key="theme.slug">
            <td
              v-if="includes(uniqueThemesArray, theme.title)"
              @click="themeToActivities(theme.title)"
              class="td-click"
            >
              {{ theme.title }}
            </td>
            <td v-else>{{ theme.title }}</td>
            <td class="text-center">
              <i
                v-if="theme.completed"
                class="fa fa-check-circle success-icon"
              ></i
              ><i v-else class="fa fa-times-circle error-icon"></i>
            </td>
          </tr>
        </table>
      </ls-tab>
      <ls-tab title="Unidades">
        <table class="t-table-light">
          <tr>
            <th>Nome</th>
            <th class="w100">Concluída</th>
          </tr>
          <tr v-for="unit in userUnits" :key="unit.slug">
            <td
              v-if="includes(uniqueUnitsArray, unit.title)"
              @click="unitToActivities(unit.title)"
              class="td-click"
            >
              {{ unit.title }}
            </td>
            <td v-else>{{ unit.title }}</td>

            <td class="text-center">
              <i
                v-if="unit.completed"
                class="fa fa-check-circle success-icon"
              ></i
              ><i v-else class="fa fa-times-circle error-icon"></i>
            </td>
          </tr>
        </table>
      </ls-tab>
      <ls-tab title="Atividades">
        <table class="t-table-light activity">
          <tr>
            <th class="v-align">Ordem</th>
            <th class="v-align">
              Tema
              <ls-dropdown
                :config="selectThemes"
                ref="dropdownTheme"
                @setSelectedOption="setSelectedTheme($event)"
              ></ls-dropdown>
            </th>
            <th class="v-align">
              Unidade
              <ls-dropdown
                :config="selectUnits"
                ref="dropdownUnit"
                @setSelectedOption="setSelectedUnit($event)"
              ></ls-dropdown>
            </th>
            <th class="v-align">Descrição</th>
            <th class="v-align">Tempo</th>
            <th class="text-center v-align">Pont.</th>
          </tr>
          <tr v-for="activities in filteredActivities" :key="activities.id">
            <td class="t-order text-center">{{ activities.order }}</td>
            <td>
              {{
                activities.theme ? activities.theme.title : activities.theme_id
              }}
            </td>
            <td>
              {{ activities.unit ? activities.unit.title : activities.unit_id }}
            </td>
            <td>{{ activities.title.text }}</td>
            <td>{{ activities.timer.totalSeconds }}s</td>
            <td class="text-center">{{ activities.pointings.totalStars }}</td>
          </tr>
        </table>
      </ls-tab>
    </ls-tabs>
  </div>
</template>

<script>
import { values, uniqBy, includes } from 'lodash'
import { formatDataHourBR } from '../utils/utils'
export default {
  props: {
    user: {
      type: [Object, Array],
      default: () => []
      /**
       * user: {}
       * game: {}
       * type: {}
       */
    },
    embeded: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      filterThemes: '',
      filterUnits: '',
      includes,
      userGame: null,
      relatorioKey: 0
    }
  },
  async mounted() {
    if (this.userCode) {
      try {
        const { data } = await this.$axios(
          `/user_games/get_from_code/${this.userCode}`
        )
        this.user.game = data.game
        this.userGame = data.game
        this.forceRerender()
      } catch (e) {
        this.errorMessage = e.toString()
      }
    }
  },
  computed: {
    userInfos() {
      return this.user.user
    },
    userCode() {
      return this.userInfos.school_student_code
    },
    userActivities() {
      if (this.userGame) return values(this.userGame.activities)
      else if (this.user.game) return values(this.user.game.activities)
    },
    userModules() {
      if (this.userGame) return values(this.userGame.modules)
      else if (this.user.game) return values(this.user.game.mudules)
    },
    userThemes() {
      if (this.userGame) return values(this.userGame.themes)
      else if (this.user.game) return values(this.user.game.themes)
    },
    userUnits() {
      if (this.userGame) return values(this.userGame.units)
      else if (this.user.game) return values(this.user.game.units)
    },
    filteredActivities() {
      let activities = this.userActivities
      if (this.filterThemes && this.filterThemes !== 'Todos os temas') {
        activities = this.userActivities.filter(el => {
          return el.theme.title === this.filterThemes
        })
      }
      if (this.filterUnits && this.filterUnits !== 'Todas as unidades') {
        activities = activities.filter(el => {
          return el.unit.title === this.filterUnits
        })
      }
      return activities
    },
    isStudent() {
      return this.user.type === 'student'
    },
    getTypeName() {
      if (this.isStudent) return 'Aluno'
      else return 'Professor'
    },
    tabStyle() {
      if (this.embeded)
        return {
          margin: '0',
          title: 'Relatório Individual',
          padding: '32'
        }
    },
    userInfosFormated() {
      return this.genetareInfo(this.userInfos)
    },
    uniqueThemes() {
      const themes = uniqBy(this.userActivities, 'theme.slug')
      const filtered = themes.map(el => {
        if (el.theme)
          return {
            value: el.theme.title
          }
      })
      return filtered
    },
    uniqueThemesArray() {
      return this.uniqueThemes.map(el => {
        if (el) return el.value
        else return
      })
    },
    uniqueUnits() {
      const units = uniqBy(this.userActivities, 'unit.slug')
      const filtered = units.map(el => {
        if (el.unit)
          return {
            value: el.unit.title
          }
      })
      return filtered
    },
    uniqueUnitsArray() {
      return this.uniqueUnits.map(el => {
        if (el) return el.value
        else return
      })
    },
    selectThemes: {
      get() {
        return {
          options: [{ value: 'Todos os temas' }, ...this.uniqueThemes],
          placeholder: 'Todos os temas'
        }
      }
    },
    selectUnits: {
      get() {
        return {
          options: [{ value: 'Todas as unidades' }, ...this.uniqueUnits],
          placeholder: 'Todas as unidades'
        }
      }
    }
  },
  methods: {
    close() {
      this.$emit('close')
    },
    forceRerender() {
      this.relatorioKey += 1
    },
    setSelectedTheme(selected) {
      this.selectThemes.placeholder = selected.value
      this.filterThemes = selected.value
    },
    setSelectedUnit(selected) {
      this.selectUnits.placeholder = selected.value
      this.filterUnits = selected.value
    },
    genetareInfo(user) {
      const info = []
      if (this.isStudent) {
        if (user.unique_session_id)
          info.push({ name: 'Sessão', value: user.unique_session_id })
        if (user.status) info.push({ name: 'Status', value: user.status })
        if (user.email) info.push({ name: 'Email', value: user.email })
        if (user.school_student_code)
          info.push({
            name: 'Código do aluno',
            value: user.school_student_code
          })
      } else {
        if (user.rg) info.push({ name: 'RG', value: user.rg })
        if (user.cpf) info.push({ name: 'CPF', value: user.cpf })
        if (user.gender) info.push({ name: 'Gênero', value: user.gender })
        if (user.school_degree_level)
          info.push({ name: 'Escolaridade', value: user.school_degree_level })
        if (user.updated_at)
          info.push({
            name: 'Último Login',
            value: formatDataHourBR(user.updated_at)
          })
        if (user.email) info.push({ name: 'Email', value: user.email })
      }
      return info
    },
    themeToActivities(title) {
      this.selectThemes.placeholder = title
      this.filterThemes = title
      this.$refs.tabs.selectTab(2)
      this.$refs.dropdownTheme.$forceUpdate()
    },
    unitToActivities(title) {
      this.selectUnits.placeholder = title
      this.filterUnits = title
      this.$refs.tabs.selectTab(2)
      this.$refs.dropdownUnit.$forceUpdate()
    }
  }
}
</script>
<style lang="scss" scoped>
#history-user {
  background-color: white;
  * {
    font-weight: bold;
  }

  .back-button {
    color: $brand-primary;
    cursor: pointer;
    i {
      margin-right: $gap;
    }
  }

  .panel-info-container {
    width: 100%;
    margin: 30px 0 50px 0;
    .panel-info {
      width: 100%;
    }
  }

  .t-table-light {
    margin-top: $gap * 2;
    .v-align {
      vertical-align: baseline;
      padding-bottom: 1px;
    }
  }

  .success-icon,
  .error-icon {
    font-size: 2rem;
  }

  .error-icon {
    color: $brand-danger;
  }

  .success-icon {
    color: $brand-success;
  }

  .td-click {
    color: $brand-primary;
    cursor: pointer;
    text-decoration: underline;
  }
}
</style>
