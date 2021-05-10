<template>
    <div id="app_vue">
        <notifications group="danger" classes="error" position="top right" />
        <notifications group="success" classes="success" position="top right" />
        <router-view></router-view>
        <modal 
            name="edit-word-images" 
            height="auto"
        >
            <EditWordImages />
        </modal>
    </div>
</template>

<script>
import { mapState } from 'vuex'
import EditWordImages from '../modals/EditWordImages'
export default {
    components: {
        EditWordImages
    },
    computed: mapState({
        'isEditModalVisible': (state) => state.isEditWordModalVisible
    }),
    async mounted() {
        const templates = await this.$axios.get('/question/templates.json')
        const groups = await this.$axios.get('/groups.json')
        
        this.$store.dispatch('groups/fetch', groups.data)
        this.$store.dispatch('templates/fetch', templates.data)
    }
}
</script>
