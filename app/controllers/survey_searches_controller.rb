class SurveySearchesController < ApplicationController
  helper_method :q, :from_date, :to_date

  def show
    @results = results
  end

  private

  def results
    response = Survey.search(
      {
        "query": {
          "bool": {
            "must": [
              {
                "match": {
                  "responses": q
                }
              },
              range: {
                started_at: {
                  gte: date_parameters_to_datetime(from_date),
                  lte: date_parameters_to_datetime(to_date),
                }
              }
            ]
          }
        }
      }
    )
    {
      total: response.results.total,
      results: response.records,
    }
  end

  def search_params
    params.permit(:q, from_date: [:day, :month, :year], to_date: [:day, :month, :year])
  end

  def from_date
    search_params.fetch(:from_date, {})
  end

  def to_date
    search_params.fetch(:to_date, {})
  end

  def q
    search_params[:q].to_s
  end

  def date_parameters_to_datetime(date_parameters)
    begin
      DateTime.new(date_parameters[:year].to_i, date_parameters[:month].to_i, date_parameters[:day].to_i).strftime('%F')
    rescue ArgumentError
      nil
    end
  end
end
