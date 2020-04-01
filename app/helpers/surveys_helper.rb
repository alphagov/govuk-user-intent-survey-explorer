module SurveysHelper
  def formatted_survey_started_at(survey)
    format_datetime(survey.started_at)
  end
end
