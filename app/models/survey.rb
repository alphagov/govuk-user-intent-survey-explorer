class Survey < ApplicationRecord
  belongs_to :organisation
  belongs_to :visitor
end
