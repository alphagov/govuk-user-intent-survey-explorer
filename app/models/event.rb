class Event < ApplicationRecord
  has_many :event_visits
  has_many :visits, through: :event_visits
end
