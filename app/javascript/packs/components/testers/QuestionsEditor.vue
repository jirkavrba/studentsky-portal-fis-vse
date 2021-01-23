<template>
  <div>
    <input type="hidden" name="tester[questions]" :value="serializedQuestions">
    <div class="ui styled fluid accordion">
      <div v-for="(question, i) in this.questions" :key="i">
        <div class="title">{{ question.text }}</div>
        <div class="content">
        </div>
      </div>
    </div>
  </div>
</template>
<script>

export default {
  name: 'QuestionsEditor',
  props: ['source'],
  data: () => ({
    questions: [],
    currentQuestion: null
  }),
  mounted: function() {
    this.questions = JSON.parse(this.source)
  },
  computed: {
    serializedQuestions: function () {
      return JSON.stringify(this.questions);
    }
  }
}

</script>
