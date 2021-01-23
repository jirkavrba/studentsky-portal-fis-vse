<template>
  <div>
    <input type="hidden" :name="name" :value="serializedQuestions">
    <div v-for="(question, i) in this.questions" :key="i" class="ui segment">
      <div class="ui top left attached label">Otázka {{ i + 1 }}</div>
      <div class="field">
        <label>Text otázky</label>
        <input type="text" v-model="questions[i].text">
      </div>
      <div class="extra content">
        <div class="field">
          <label>Odpovědi</label>
          <div v-if="question.answers.length === 0" class="ui basic segment">
            <span class="ui grey text">
              Tato otázka zatím nemá žádné odpovědi
            </span>
          </div>
          <div v-for="(answer, j) in question.answers" :key="j" class="field">
            <div class="ui action input">
              <div :class="'ui icon button' + (answer.correct ? ' green' : '')" @click="toggleAnswer(i, j)">
                <i :class="'icon ' + (answer.correct ? 'check' : 'times')"></i>
              </div>
              <input type="text" v-model="questions[i].answers[j].text" placeholder="Text odpovědi">
              <div :class="'ui icon button'" @click="removeAnswer(i, j)">
                <i class="trash icon"></i>
              </div>
            </div>
          </div>
          <div class="ui tiny button" @click="addAnswerToQuestion(i)">Přidat odpověď</div>
          <div class="ui tiny red button" @click="removeQuestion(i)">Smazat otázku</div>
        </div>
      </div>
    </div>
    <div>
      <div class="ui green button" @click="addQuestion">Přidat otázku</div>
    </div>
  </div>
</template>
<script>

export default {
  name: 'QuestionsEditor',
  props: ['source', 'name'],
  data: () => ({
    questions: [],
  }),
  mounted: function () {
    this.questions = JSON.parse(this.source);
  },
  methods: {
    addQuestion: function () {
      this.questions.push({
        text: "",
        answers: []
      })
    },
    removeQuestion: function (i) {
      this.questions.splice(i, 1)
    },
    toggleAnswer: function (i, j) {
      this.questions[i].answers[j].correct = !this.questions[i].answers[j].correct
    },
    removeAnswer: function (i, j) {
      this.questions[i].answers.splice(j, 1)
    },
    addAnswerToQuestion: function (i) {
      this.questions[i].answers.push({
        text: "",
        correct: false
      })
    }
  },
  computed: {
    serializedQuestions: function () {
      return JSON.stringify(this.questions);
    }
  }
}

</script>
