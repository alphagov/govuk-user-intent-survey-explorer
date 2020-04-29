class Phrase < ApplicationRecord
  has_many :mentions, dependent: :destroy
  has_many :survey_answers, through: :mentions
end
