class GenericPhrase < ApplicationRecord
  belongs_to :verb
  belongs_to :adjective
  has_many :phrase_generic_phrases, dependent: :destroy
  include ::GenericPhraseConcern

  def self.search(start_date, end_date, options = {})
    options = {
      sort_key: "generic_phrase",
      sort_dir: :asc,
      verb: "%",
      adjective: "%",
    }.merge!(options)

    date_range = start_date..end_date

    GenericPhrase
      .joins(:verb, :adjective, phrase_generic_phrases: [{ phrase: [{ mentions: [{ survey_answer: :survey }] }] }])
      .where("surveys.started_at" => date_range)
      .where("verbs.name like ?", options[:verb])
      .where("adjectives.name like ?", options[:adjective])
      .group("generic_phrases.id, verbs.name, adjectives.name")
      .order("#{options[:sort_key]} #{options[:sort_dir]}")
      .pluck("generic_phrases.id", "concat(verbs.name, '-', adjectives.name) as generic_phrase", "verbs.name as verb", "adjectives.name as adj")
  end

  def self.most_frequent_co_occurring(generic_phrase, start_date, end_date)
    date_range = start_date..end_date

    survey_answers_for_generic_phrase = Mention
                                          .select("distinct(mentions.survey_answer_id) as id")
                                          .joins(phrase: :phrase_generic_phrases, survey_answer: :survey)
                                          .where("phrase_generic_phrases.generic_phrase_id" => generic_phrase.id, "surveys.started_at" => date_range)
                                          .pluck("mentions.survey_answer_id")

    generic_phrases_for_survey_answers = GenericPhrase
                                           .joins(:verb, :adjective, phrase_generic_phrases: [{ phrase: :mentions }])
                                           .where("mentions.survey_answer_id" => survey_answers_for_generic_phrase)
                                           .group("mentions.survey_answer_id, verbs.name, adjectives.name")
                                           .order("concat(verbs.name, '-', adjectives.name) asc")
                                           .pluck("mentions.survey_answer_id", "concat(verbs.name, '-', adjectives.name)")

    generic_phrase_combinations = co_occurring_generic_phrases(generic_phrases_for_survey_answers)
    generic_phrase_combinations
      .each_with_object({}) { |(a, b), hsh| hsh["#{a}-#{b}"] = generic_phrase_combinations.count([a, b]) }
      .sort_by { |generic_phrase_pair, occurrences| [-occurrences, generic_phrase_pair] }
  end

  def to_s
    "#{verb.name}-#{adjective.name}"
  end
end
