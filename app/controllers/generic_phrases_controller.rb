class GenericPhrasesController < ApplicationController
  include Searchable

  def index
    options = {
      page: page,
      sort_key: sort_key,
      sort_direction: sort_dir,
      verb: verb,
      adjective: adjective,
    }

    @presenter = GenericPhrasesPresenter.new(generic_phrase_results, verb_results, adjective_results, search_params, options)
  end

  def show
    generic_phrase = GenericPhrase.find(params[:id])

    @presenter = GenericPhrasePresenter.new(generic_phrase, most_frequent_exact_matches(generic_phrase),
                                            mentions(generic_phrase), survey_answers(generic_phrase),
                                            most_frequent_co_occurring_generic_phrases(generic_phrase))
  end

private

  def generic_phrase_results
    options = {
      sort_key: sort_key,
      sort_dir: sort_dir,
    }

    options[:verb] = verb if verb.present?
    options[:adjective] = adjective if adjective.present?

    GenericPhrase.search(from_date_as_datetime, to_date_as_datetime, options)
  end

  def verb_results
    Verb.unique_sorted.map(&:name)
  end

  def adjective_results
    Adjective.unique_sorted.map(&:name)
  end

  def most_frequent_exact_matches(generic_phrase)
    Phrase
      .most_frequent_for_generic_phrase(generic_phrase, from_date_as_datetime, to_date_as_datetime)
      .take(10)
  end

  def most_frequent_co_occurring_generic_phrases(generic_phrase)
    GenericPhrase
      .most_frequent_co_occurring(generic_phrase, from_date_as_datetime, to_date_as_datetime)
      .take(10)
  end

  def mentions(generic_phrase)
    Mention.mentions_by_date_range_for_generic_phrase(generic_phrase, from_date_as_datetime, to_date_as_datetime)
  end

  def survey_answers(generic_phrase)
    SurveyAnswer
      .for_generic_phrase(generic_phrase, from_date_as_datetime, to_date_as_datetime)
      .take(3)
  end

  def sort_key
    default_key = "generic_phrase"

    if params[:sort_key].present?
      %w[generic_phrase verb adj].include?(params[:sort_key]) ? params[:sort_key] : default_key
    else
      default_key
    end
  end

  def sort_dir
    params[:sort_direction] == "desc" ? :desc : :asc
  end

  def page
    params[:page] || 1
  end

  def verb
    verb_param = params.permit(:verb).fetch(:verb, "")

    verb_results.include?(verb_param) ? verb_param : ""
  end

  def adjective
    adjective_param = params.permit(:adjective).fetch(:adjective, "")

    adjective_results.include?(adjective_param) ? adjective_param : ""
  end
end
