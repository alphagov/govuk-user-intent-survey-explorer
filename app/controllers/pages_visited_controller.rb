class PagesVisitedController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @presenter = PagesVisitedPresenter.new(unique_visitors_by_page, search_params)
  end

private

  def unique_visitors_by_page
    Page.find_by_sql("select pages.*, count(distinct(page_visits.visit_id)) as unique_visitors from pages join page_visits on page_visits.page_id = pages.id group by pages.id order by #{search_params[:sort_key]} #{search_params[:sort_direction]}")
  end

  def search_params
    @search_params ||= begin
      sort_keys = %w(base_path unique_visitors)

      defaults = {
        page: 1
      }.merge(
        params.permit(
          :page,
        ).to_h.symbolize_keys
      )

      defaults[:sort_key] = sort_keys.include?(params[:sort_key]) ? params[:sort_key] : 'unique_visitors'
      defaults[:sort_direction] = params[:sort_direction] == 'asc' ? :asc : :desc

      defaults
    end
  end
end
