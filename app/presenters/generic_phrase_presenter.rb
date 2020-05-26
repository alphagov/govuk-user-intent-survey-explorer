class GenericPhrasePresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TagHelper
  attr_reader :generic_phrase, :most_frequent_exact_matches, :mentions, :survey_answers

  def initialize(generic_phrase, most_frequent_exact_matches, mentions, survey_answers, most_frequent_co_occurring_generic_phrases)
    @generic_phrase = generic_phrase
    @most_frequent_exact_matches = most_frequent_exact_matches
    @mentions = mentions
    @survey_answers = survey_answers
    @most_frequent_co_occurring_generic_phrases = most_frequent_co_occurring_generic_phrases
  end

  def first_appeared_at
    generic_phrase.first_appeared_at.strftime("#{generic_phrase.first_appeared_at.day.ordinalize} %B %Y")
  end

  def title
    "Generic phrase #{generic_phrase}"
  end

  def most_frequent_co_occurring_generic_phrases
    @most_frequent_co_occurring_generic_phrases.map do |this_generic_phrase, other_generic_phrase, number_of_occurrences|
      text = content_tag(:span, "#{this_generic_phrase} & ") + content_tag(:a, other_generic_phrase, href: generic_phrase_path(other_generic_phrase))

      [
        {
          text: text,
        },
        {
          text: number_of_occurrences,
          format: "numeric",
        },
      ]
    end
  end
end
