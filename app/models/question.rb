class Question < ApplicationRecord
  has_many :survey_answers
  has_many :surveys, through: :survey_answers
end
