module PagesHelper
  def present_answers_by_question(answers_by_question)
    answers_by_question.map do |question, answers|
      {
        heading: { text: question.question_text },
        content: { html: sanitize(answers_text(answers)) },
      }
    end
  end

  def answers_text(answers)
    answers.map { |answer| "<p class='govuk-body'>#{answer.answer}</p>" }.join("")
  end
end
