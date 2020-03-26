module VisitsHelper
  def formatted_date_and_time(visit)
    visit.ga_visit_start_at.strftime("%d-%m-%y at %H:%M")
  end
end
