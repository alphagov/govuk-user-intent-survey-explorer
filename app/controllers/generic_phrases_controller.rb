class GenericPhrasesController < ApplicationController
  def index
    @presenter = GenericPhrasesPresenter.new(generic_phrase_results, search_params)
  end

private
  def generic_phrase_results
    GenericPhrase.search(Date.new(2020, 4, 1), Date.new(2020, 4, 7), sort_key: search_params[:sort_key], sort_dir: search_params[:sort_direction])
  end

  def search_params
    @search_params ||= begin
      sort_keys = %w[generic_phrase verb adj]

      defaults = {
       page: 1,
      }.merge(
       params.permit(
         :sort_key,
         :sort_direction,
         :page,
         ).to_h.symbolize_keys,
       )

      defaults[:sort_key] = sort_keys.include?(params[:sort_key]) ? params[:sort_key] : "generic_phrase"
      defaults[:sort_direction] = params[:sort_direction] == "desc" ? :desc : :asc

      defaults
    end
  end
end
