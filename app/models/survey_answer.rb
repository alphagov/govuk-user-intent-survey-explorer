class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  has_many :survey_phrases, dependent: :destroy
  has_many :phrases, through: :survey_phrases
end
