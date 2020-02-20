class Search < ApplicationRecord
  has_many :search_visits
  has_many :visits, through: :search_visits
end
