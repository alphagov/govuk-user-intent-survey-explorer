class Question < ApplicationRecord
  has_many :visits
  has_many :surveys, through: :visits
end
