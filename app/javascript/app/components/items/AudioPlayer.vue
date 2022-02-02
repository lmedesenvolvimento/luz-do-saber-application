<template>
  <div class="audio-player-component">
    <div
      v-show="audioUrl && containsAudio"
      class="panel panel-default panel--player"
    >
      <vue-plyr ref="plyr">
        <audio />
      </vue-plyr>
    </div>
    <div v-if="!containsAudio && showMessage" class="message">
      *{{ message }} não contém áudio.
    </div>
  </div>
</template>

<script>
export default {
  name: 'AudioPlayer',
  props: {
    audioUrl: {
      type: String,
      default: ''
    },
    message: {
      type: String,
      default: 'Essa palavra'
    }
  },
  data() {
    return {
      containsAudio: false
    }
  },
  computed: {
    player() {
      return this.$refs.plyr.player
    },
    showMessage() {
      if (this.audioUrl) {
        return this.audioUrl.length > 0
      } else return false
    }
  },
  watch: {
    async audioUrl() {
      if (!this.audioUrl) {
        this.containsAudio = false
        return
      }

      const containsAudio = await fetch(this.audioUrl).then(resp => {
        return resp.ok
      })

      if (!containsAudio) {
        this.containsAudio = false
        return
      }

      this.containsAudio = containsAudio

      this.player.source = {
        type: 'audio',
        sources: [
          {
            src: this.audioUrl,
            type: 'audio/mp3'
          }
        ]
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.audio-player-component {
  .message {
    display: flex;
    align-items: center;
    min-height: 32px;
    font-style: italic;
  }
}
</style>
