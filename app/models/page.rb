class Page < ApplicationRecord
  has_many :page_visits
  has_many :visits, through: :page_visits
end
