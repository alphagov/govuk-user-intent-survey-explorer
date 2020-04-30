class Visitor < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_many :surveys, dependent: :destroy
end
