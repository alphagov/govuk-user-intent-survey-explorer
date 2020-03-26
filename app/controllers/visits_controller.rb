class VisitsController < ApplicationController
  def index
    @visits = Visit.all.order(:ga_visit_start_at).group_by { |visit| visit.ga_visit_start_at.strftime("%d-%m-%y") }
  end

  def show
    @visit = Visit.find(params[:id])
    @visit_before = Visit.where("ga_visit_start_at < ?", @visit.ga_visit_start_at).order(:ga_visit_start_at).last
    @visit_after = Visit.where("ga_visit_start_at > ?", @visit.ga_visit_start_at).order(:ga_visit_start_at).first
  end
end
