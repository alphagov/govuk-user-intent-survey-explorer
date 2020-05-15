class GenericPhrasePresenter
  attr_reader :generic_phrase, :title, :most_frequent_exact_matches, :mentions, :survey_answers

  def initialize(generic_phrase, most_frequent_exact_matches, mentions, survey_answers)
    @generic_phrase = generic_phrase
    @most_frequent_exact_matches = most_frequent_exact_matches
    @mentions = mentions
    @survey_answers = survey_answers
  end

  def first_appeared_at
    Date.new(2020, 4, 1)
  end

  def survey_responses
    []
  end

  def title
    "Generic phrase #{generic_phrase}"
  end
end