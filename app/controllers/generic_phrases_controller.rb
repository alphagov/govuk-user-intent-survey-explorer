class GenericPhrasesController < ApplicationController
  include Searchable

  def index
    @presenter = GenericPhrasesPresenter.new(generic_phrase_results, verb_results, adjective_results, search_options)
  end

  def show
    @generic_phrase = GenericPhrase.find(params[:id])

    @presenter = GenericPhrasePresenter.new(@generic_phrase, most_frequent_exact_matches,
                                            mentions, survey_answers,
                                            most_frequent_co_occurring_generic_phrases)
  end

private

  def generic_phrase_results
    @generic_phrase_results ||= GenericPhrase.search(from_date_as_datetime, to_date_as_datetime, search_options)
  end

  def most_frequent_exact_matches
    @most_frequent_exact_matches ||= begin
      Phrase
        .most_frequent_for_generic_phrase(@generic_phrase, from_date_as_datetime, to_date_as_datetime)
        .take(10)
    end
  end

  def most_frequent_co_occurring_generic_phrases
    @most_frequent_co_occurring_generic_phrases ||= begin
      GenericPhrase
        .most_frequent_co_occurring(@generic_phrase, from_date_as_datetime, to_date_as_datetime)
      .take(10)
    end
  end

  def mentions
    @mentions ||= Mention.mentions_by_date_range_for_generic_phrase(@generic_phrase, from_date_as_datetime, to_date_as_datetime)
  end

  def survey_answers
    @survey_answers ||= begin
      SurveyAnswer
        .for_generic_phrase(@generic_phrase, from_date_as_datetime, to_date_as_datetime)
        .take(3)
    end
  end

  def default_sort_key
    "generic_phrase"
  end

  def allowed_sort_keys
    %w[generic_phrase verb adj]
  end
end
