class PagesController < ApplicationController
  include Searchable
  helper_method :sort_key, :sort_dir

  def show
    base_path = request.path.sub("/page", "")
    @page = Page.find_by(base_path: base_path)
    @presenter = PagePresenter.new(@page, survey_counts, top_generic_phrases, top_user_groups)
  end

  def index
    @presenter = PagesPresenter.new(pages, search_page, search_params, sort_key, sort_dir, from_date_as_datetime, to_date_as_datetime)
  end

private

  def pages
    @pages ||= begin
      Page.search_by_base_path(q, from_date_as_datetime, to_date_as_datetime, sort_key, sort_dir)
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
end
