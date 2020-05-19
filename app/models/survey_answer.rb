class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  has_many :mentions, dependent: :destroy
  has_many :phrases, through: :mentions

  def self.for_phrase(phrase, start_date, end_date)
    date_range = start_date..end_date

    SurveyAnswer.joins(:question, :survey, mentions: :phrase)
      .where("phrases.id" => phrase.id, "questions.question_number" => 3, "surveys.started_at" => date_range)
      .where("survey_answers.answer not like '-'")
  end

  def self.for_generic_phrase(generic_phrase, start_date, end_date)
    date_range = start_date..end_date

    SurveyAnswer.joins(:question, :survey, mentions: [{ phrase: :phrase_generic_phrases }])
      .where("phrase_generic_phrases.generic_phrase_id" => generic_phrase.id, "questions.question_number" => 3, "surveys.started_at" => date_range)
      .where("survey_answers.answer not like '-'")
  end
end
