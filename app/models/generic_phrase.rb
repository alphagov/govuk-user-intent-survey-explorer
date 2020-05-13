class GenericPhrase < ApplicationRecord
  belongs_to :verb
  belongs_to :adjective
  has_many :phrase_generic_phrases, dependent: :destroy

  def self.search(start_date, end_date, sort_key: "generic_phrase", sort_dir: :asc, verb: "%", adjective: "%")
    date_range = start_date..end_date

    GenericPhrase
      .joins(:verb, :adjective, phrase_generic_phrases: [{ phrase: [{ mentions: [{ survey_answer: :survey }] }] }])
      .where("surveys.started_at" => date_range)
      .where("verbs.name like ?", verb)
      .where("adjectives.name like ?", adjective)
      .group("generic_phrases.id, verbs.name, adjectives.name")
      .order("#{sort_key} #{sort_dir}")
      .pluck("generic_phrases.id", "concat(verbs.name, '-', adjectives.name) as generic_phrase", "verbs.name as verb", "adjectives.name as adj")
  end
end
