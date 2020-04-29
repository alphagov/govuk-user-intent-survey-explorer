class PagesVisitedController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @presenter = PagesVisitedPresenter.new(unique_visitors_by_page, search_params)
  end

private

  def unique_visitors_by_page
    Page.find_by_sql("select pages.id, pages.base_path, count(distinct(pv.visit_id)) as unique_visitors from mentions m join phrases on phrases.id = m.phrase_id join survey_answers sa on sa.id = m.survey_answer_id join surveys s on s.id = sa.survey_id join visits v on v.visitor_id = s.visitor_id join page_visits pv on pv.visit_id = v.id join pages on pages.id = pv.page_id where phrases.id = #{@phrase.id} group by (pages.id) order by #{search_params[:sort_key]} #{search_params[:sort_direction]};")
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
