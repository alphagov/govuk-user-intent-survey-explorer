class Channel < ApplicationRecord
  has_many :visits, dependent: :destroy
end
