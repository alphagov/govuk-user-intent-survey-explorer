class Phrase < ApplicationRecord
  has_many :survey_phrases, dependent: :destroy
  has_many :survey_answers, through: :survey_phrases
end
