class Visit < ApplicationRecord
  belongs_to :visitor
  belongs_to :device
  belongs_to :channel
end
