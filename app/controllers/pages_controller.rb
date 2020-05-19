class PagesController < ApplicationController
  include Searchable
  helper_method :sort_key, :sort_dir

  def show
    base_path = request.path.sub("/page", "")
    @page = Page.find_by(base_path: base_path)
    @presenter = PagePresenter.new(@page, survey_counts, top_generic_phrases, top_user_groups, top_visits_last_page, top_visits_next_page, survey_answers, devices)
  end

  def index
    @presenter = PagesPresenter.new(pages, verb_results, adjective_results, search_page, search_params, search_options, from_date_as_datetime, to_date_as_datetime)
  end

private

  def pages
    @pages ||= begin
      Page.search_by_base_path(q, from_date_as_datetime, to_date_as_datetime, search_options)
    end
  end

  def survey_counts
    @survey_counts ||= Survey.count_by_date(@page, from_date_as_datetime, to_date_as_datetime)
  end

  def top_generic_phrases
    @top_generic_phrases ||= GenericPhrase.most_frequent_for_page(@page, from_date_as_datetime, to_date_as_datetime).take(3)
  end

  def top_user_groups
    @top_user_groups ||= UserGroup.top_user_groups_for_page(@page, from_date_as_datetime, to_date_as_datetime).take(3)
  end

  def verb_results
    Verb.unique_sorted.map(&:name)
  end

  def adjective_results
    Adjective.unique_sorted.map(&:name)
  end

  def top_visits_last_page
    @top_visits_last_page ||= Page.top_visits_last_page(@page, from_date_as_datetime, to_date_as_datetime).take(10)
  end

  def top_visits_next_page
    @top_visits_next_page ||= Page.top_visits_next_page(@page, from_date_as_datetime, to_date_as_datetime).take(10)
  end

  def survey_answers
    @survey_answers ||= SurveyAnswer.for_page(@page, from_date_as_datetime, to_date_as_datetime).take(3)
  end

  def devices
    @devices ||= Device.for_page(@page, from_date_as_datetime, to_date_as_datetime)
  end

  def sort_key
    default_key = "feedback_comments"
    key = params[:sort_key] || default_key
    %w[page_base_path feedback_comments].include?(key) ? key : default_key
  end

  def sort_dir
    default_dir = "desc"
    dir = params[:sort_dir] || default_dir
    %w[desc asc].include?(dir) ? dir : default_dir
  end

  def search_page
    params[:page] ||= 0
  end

  def verb
    verb_param = params.permit(:verb).fetch(:verb, "")

    verb_results.include?(verb_param) ? verb_param : ""
  end

  def adjective
    adjective_param = params.permit(:adjective).fetch(:adjective, "")

    adjective_results.include?(adjective_param) ? adjective_param : ""
  end

  def search_options
    options = {
      sort_key: sort_key,
      sort_dir: sort_dir,
    }

    options[:verb] = verb if verb.present?
    options[:adjective] = adjective if adjective.present?

    options
  end
end
