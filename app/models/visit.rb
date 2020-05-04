class Visit < ApplicationRecord
  belongs_to :visitor
  belongs_to :device
  belongs_to :channel
  has_many :page_visits, dependent: :destroy
  has_many :pages, -> { order(:sequence) }, through: :page_visits
  has_many :search_visits, dependent: :destroy
  has_many :searches, -> { order(:sequence) }, through: :search_visits
  has_many :event_visits, dependent: :destroy
  has_many :events, -> { order(:sequence) }, through: :event_visits
  has_many :survey_visit, dependent: :destroy
end
