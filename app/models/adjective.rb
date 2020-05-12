class Adjective < ApplicationRecord
  has_many :generic_phrases, dependent: :destroy

  def self.unique_sorted
    Adjective.distinct.order(:name)
  end
end
