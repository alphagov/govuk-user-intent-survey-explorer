class GenericPhrasePresenter
  attr_reader :generic_phrase, :title, :most_frequent_exact_matches, :mentions

  def initialize(generic_phrase, most_frequent_exact_matches, mentions)
    @generic_phrase = generic_phrase
    @most_frequent_exact_matches = most_frequent_exact_matches
    @mentions = mentions
  end

  def first_appeared_at
    Date.new(2020, 4, 1)
  end

  def survey_answers_containing_phrase
    []
  end

  def survey_responses
    []
  end

  def title
    "Generic phrase #{generic_phrase}"
  end
end