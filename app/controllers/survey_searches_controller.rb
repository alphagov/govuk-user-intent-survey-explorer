class SurveySearchesController < ApplicationController
  include Searchable

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
                  "responses": q,
                },
              },
              range: {
                started_at: {
                  gte: date_parameters_to_datetime(from_date).strftime("%F"),
                  lte: date_parameters_to_datetime(to_date).strftime("%F"),
                },
              },
            ],
          },
        },
      },
    )
    {
      total: response.results.total,
      results: response.records,
    }
  end
end
