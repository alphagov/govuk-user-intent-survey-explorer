class PagesVisitedController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @unique_visitors_by_page = Page.find_by_sql('select pages.*, count(distinct(page_visits.visit_id)) as unique_visitors from pages join page_visits on page_visits.page_id = pages.id group by pages.id order by unique_visitors desc')
  end
end
