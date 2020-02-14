class Visit < ApplicationRecord
  belongs_to :visitor
  belongs_to :device
  belongs_to :channel
  has_many :page_visits
  has_many :pages, through: :page_visits
end
