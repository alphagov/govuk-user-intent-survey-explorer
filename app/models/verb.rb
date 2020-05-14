class Verb < ApplicationRecord
  has_many :generic_phrases, dependent: :destroy

  def self.unique_sorted
    Verb.distinct.order(:name)
  end
end
