class GenericPhrasesController < ApplicationController
  def index
    @presenter = GenericPhrasesPresenter.new(generic_phrase_results, search_params)
  end

private
  def generic_phrase_results
    GenericPhrase.for_date_range(Date.new(2020, 4, 1), Date.new(2020, 4, 7))
  end

  def search_params
    @search_params ||= begin
      sort_keys = %w[generic_phrase verb adjective]

      defaults = {
       q: "",
       page: 1,
      }.merge(
       params.permit(
         :q,
         :page,
         ).to_h.symbolize_keys,
       )

      defaults[:sort_key] = sort_keys.include?(params[:sort_key]) ? params[:sort_key] : "generic_phrase"
      defaults[:sort_direction] = params[:sort_direction] == "asc" ? :asc : :desc

      defaults
    end
  end
end
