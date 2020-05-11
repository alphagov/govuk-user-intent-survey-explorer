class GenericPhrase < ApplicationRecord
  belongs_to :verb
  belongs_to :adjective
  has_many :phrase_generic_phrases, dependent: :destroy
end
