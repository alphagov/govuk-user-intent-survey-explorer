class GenericPhrase < ApplicationRecord
  belongs_to :verb
  belongs_to :adjective
  has_many :phrase_generic_phrases, dependent: :destroy

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

  def self.most_frequent(start_date, end_date)
    date_range = start_date..end_date

    GenericPhrase
      .select("generic_phrases.id, verbs.name, adjectives.name, count(phrase_generic_phrases.generic_phrase_id) as total_mentions")
      .joins(:verb, :adjective, phrase_generic_phrases: [{ phrase: [{ mentions: [{ survey_answer: :survey }] }] }])
      .where("surveys.started_at" => date_range)
      .group("generic_phrases.id, verbs.name, adjectives.name")
      .order("total_mentions desc, verbs.name asc, adjectives.name asc")
      .pluck("generic_phrases.id", "concat(verbs.name, '-', adjectives.name)", "count(phrase_generic_phrases.generic_phrase_id) as total_mentions")
  end

  def self.most_frequent_co_occurring(generic_phrase, start_date, end_date)
    date_range = start_date..end_date

    survey_answers_for_generic_phrase = Mention
                                          .select("distinct(mentions.survey_answer_id) as id")
                                          .joins(phrase: :phrase_generic_phrases, survey_answer: :survey)
                                          .where("phrase_generic_phrases.generic_phrase_id" => generic_phrase.id, "surveys.started_at" => date_range)
                                          .pluck("mentions.survey_answer_id")

    generic_phrases_for_survey_answers = GenericPhrase
                                           .joins(phrase_generic_phrases: [{ phrase: :mentions }])
                                           .where("mentions.survey_answer_id" => survey_answers_for_generic_phrase)
                                           .group("mentions.survey_answer_id, phrase_generic_phrases.generic_phrase_id")
                                           .pluck("mentions.survey_answer_id", "phrase_generic_phrases.generic_phrase_id")

    unique_generic_phrase_ids = generic_phrases_for_survey_answers.map { |_, id, _| id }.uniq
    generic_phrases_by_id = generic_phrase_lookup_for_ids(unique_generic_phrase_ids)

    generic_phrase_combinations = co_occurring_generic_phrases(generic_phrases_for_survey_answers, generic_phrase).map do |id1, id2|
      other_phrase_id = id1 == generic_phrase.id ? id2 : id1
      [generic_phrase.id, other_phrase_id]
    end

    generic_phrase_pair_counts = generic_phrase_combinations
      .each_with_object({}) do |(id1, id2), hsh|
        hsh[[id1, id2]] = generic_phrase_combinations.count([id1, id2])
      end

    generic_phrase_pair_counts
      .map { |(id1, id2), count| [generic_phrases_by_id[id1], generic_phrases_by_id[id2], count] }
      .sort_by { |generic_phrase1, generic_phrase2, count| [-count, "#{generic_phrase1}-#{generic_phrase2}"] }
  end

  def self.most_frequent_for_page(page, start_date, end_date)
    date_range = start_date..end_date

    GenericPhrase
        .select("generic_phrases.id, verbs.name, adjectives.name, count(phrase_generic_phrases.generic_phrase_id) as total_mentions")
        .joins(:verb, :adjective, phrase_generic_phrases: [{ phrase: [{ mentions: [{ survey_answer: [{ survey: [{ survey_visit: [{ visit: :page_visits }] }] }] }] }] }])
        .where("surveys.started_at" => date_range)
        .where("page_visits.page_id" => page.id)
        .group("generic_phrases.id, verbs.name, adjectives.name")
        .order("total_mentions desc, verbs.name asc, adjectives.name asc")
        .pluck("concat(verbs.name, '-', adjectives.name)", "count(phrase_generic_phrases.generic_phrase_id) as total_mentions")
        .map { |phrase_text, total| { phrase_text: phrase_text, total: total } }
  end

  def first_appeared_at
    first_survey_mentioning_generic_phrase = Survey
      .joins(survey_answers: [{ mentions: [{ phrase: :phrase_generic_phrases }] }])
      .where("phrase_generic_phrases.generic_phrase_id" => id)
      .order("surveys.started_at asc")
      .limit(1)
      .first

    first_survey_mentioning_generic_phrase.started_at
  end

  def to_s
    "#{verb.name}-#{adjective.name}"
  end

  def self.co_occurring_generic_phrases(generic_phrases_for_survey_answers, generic_phrase)
    generic_phrase_combinations = []

    generic_phrases_for_survey_answers.group_by(&:first).each do |_, survey_answer_id_generic_phrases_pair|
      # Anything less than two generic phrases will automatically be removed here
      generic_phrase_combinations += survey_answer_id_generic_phrases_pair
                                       .map { |_, generic_phrase_id, _| generic_phrase_id }.combination(2)
                                       .select { |ids| ids.include?(generic_phrase.id) }
    end

    generic_phrase_combinations
  end

  def self.generic_phrase_lookup_for_ids(generic_phrase_ids)
    GenericPhrase.joins(%i[verb adjective])
      .where(id: generic_phrase_ids)
      .index_by(&:id)
  end

  private_class_method :co_occurring_generic_phrases, :generic_phrase_lookup_for_ids
end
