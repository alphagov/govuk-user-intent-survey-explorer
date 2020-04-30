class Question < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_many :surveys, through: :visits
end
