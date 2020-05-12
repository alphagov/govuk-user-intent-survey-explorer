class GenericPhrase < ApplicationRecord
  belongs_to :verb
  belongs_to :adjective
  has_many :phrase_generic_phrases, dependent: :destroy

  def self.for_date_range(start_date, end_date)
    date_range = start_date..end_date

    GenericPhrase
      .joins(:verb, :adjective, phrase_generic_phrases: [{ phrase: [{ mentions: [{ survey_answer: :survey }] }] }])
      .where("surveys.started_at" => date_range)
      .group("generic_phrases.id, verbs.name, adjectives.name")
      .order("verbs.name, adjectives.name asc")
      .pluck("generic_phrases.id", "verbs.name as verb", "adjectives.name as adjective")
  end
end
