class SurveyPhrase < ApplicationRecord
  belongs_to :phrase
  belongs_to :survey_answer
end
