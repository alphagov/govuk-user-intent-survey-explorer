class SummaryController < ApplicationController

  def index
    @presenter = SummaryPresenter.new(results, search_params)
  end

private

  def results
    Page.find_by_sql(["select pages.id, pages.base_path, count(page_visits.visit_id) as total_pageviews, count(distinct(page_visits.visit_id)) as unique_visits from pages join page_visits on page_visits.page_id = pages.id where pages.base_path like ? group by pages.id, pages.base_path order by #{search_params[:sort_key]} #{search_params[:sort_direction]};", "%#{search_params[:q]}%"])
  end

  def search_params
    @search_params ||= begin
      sort_keys = ["base_path", "total_pageviews", "unique_visits"]

      defaults = {
        q: '',
        page: 1
      }.merge(
        params.permit(
          :q,
          :page,
        ).to_h.symbolize_keys
      )

      defaults[:sort_key] = sort_keys.include?(params[:sort_key]) ? params[:sort_key] : "total_pageviews"
      defaults[:sort_direction] = params[:sort_direction] == "asc" ? :asc : :desc

      defaults
    end
  end
end
