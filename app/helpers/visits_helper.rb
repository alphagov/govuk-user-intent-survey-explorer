module VisitsHelper
  def formatted_visit_started_at(visit)
    format_datetime(visit.ga_visit_start_at)
  end
end
