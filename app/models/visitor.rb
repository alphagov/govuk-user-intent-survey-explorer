class Visitor < ApplicationRecord
  has_many :visits
  has_many :surveys
end
