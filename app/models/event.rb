class Event < ApplicationRecord
  has_many :event_visits, dependent: :destroy
  has_many :visits, through: :event_visits
end
