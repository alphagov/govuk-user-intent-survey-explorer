class SurveySearchesController < ApplicationController
  def show
    @results = results
  end

  private

  def results
    response = Survey.search params[:q].to_s.gsub("/", "")
    {
      total: response.results.total,
      results: response.records,
    }
  end
end
