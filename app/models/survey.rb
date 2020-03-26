class Survey < ApplicationRecord
  belongs_to :organisation
  belongs_to :visitor
  has_many :visits
  has_many :questions, through: :visits
  has_many :survey_answers, -> { order(:question_id) }
end
