class PagesController < ApplicationController
  include Searchable

  def show
    base_path = request.path.sub("/page", "")
    @page = Page.find_by(base_path: base_path)
    @presenter = PagePresenter.new(@page, survey_counts, top_generic_phrases, top_user_groups, top_visits_last_page, top_visits_next_page, survey_answers, devices)
  end

  def index
    @presenter = PagesPresenter.new(pages, verb_results, adjective_results, search_options, from_date_as_datetime, to_date_as_datetime)
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

  def default_sort_key
    "feedback_comments"
  end

  def default_sort_dir
    :desc
  end

  def allowed_sort_keys
    %w[page_base_path feedback_comments]
  end
end
