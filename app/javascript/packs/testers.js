import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import QuestionsEditor from './components/testers/QuestionsEditor'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#questions_editor',
    data: () => {
      return {
        message: "Can you say hello?"
      }
    },
    components: { QuestionsEditor }
  })
})
