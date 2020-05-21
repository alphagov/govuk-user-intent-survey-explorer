class PagesVisitedController < ApplicationController
  include Searchable

  def show
    phrase = Phrase.find(params[:id])
    @presenter = PagesVisitedPresenter.new(phrase, unique_visitors_by_page(phrase), search_params)
  end

private

  def unique_visitors_by_page(phrase)
    Page.unique_visitors_for_phrase(phrase, from_date_as_datetime, to_date_as_datetime)
  end

  def search_params
    @search_params ||= begin
      sort_keys = %w[base_path unique_visitors]

      defaults = {
        page: 1,
      }.merge(
        params.permit(
          :page,
        ).to_h.symbolize_keys,
      )

      defaults[:sort_key] = sort_keys.include?(params[:sort_key]) ? params[:sort_key] : "unique_visitors"
      defaults[:sort_direction] = params[:sort_direction] == "asc" ? :asc : :desc

      defaults
    end
  end
end
