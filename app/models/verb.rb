class Verb < ApplicationRecord
  has_many :generic_phrases, dependent: :destroy
end
