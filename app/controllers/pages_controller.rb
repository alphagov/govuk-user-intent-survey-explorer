class PagesController < ApplicationController
  include Searchable
  helper_method :sort_key, :sort_dir

  def show
    @page = Page.find(params[:id])
    surveys = Survey.where(full_path: @page.base_path)
    @survey_count = surveys.count
    @answers_by_question = surveys.each_with_object(Hash.new { |h, k| h[k] = [] }) do |survey, grouped_answers|
      survey.survey_answers.each do |survey_answer|
        grouped_answers[survey_answer.question] << survey_answer
      end
    end
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
