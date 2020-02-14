class Survey < ApplicationRecord
  belongs_to :organisation
  belongs_to :visitor
  has_many :survey_answers
  has_many :questions, through: :survey_answers
end
