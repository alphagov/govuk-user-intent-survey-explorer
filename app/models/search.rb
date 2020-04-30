class Search < ApplicationRecord
  has_many :search_visits, dependent: :destroy
  has_many :visits, through: :search_visits
end
