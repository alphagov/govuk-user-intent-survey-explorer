module SurveySearchesHelper
  def present_results(results)
    results[:results].map do |survey|
      {
        link: {
          text: "Survey started on #{formatted_survey_started_at(survey)}",
          path: survey_path(survey),
        }
      }
    end
  end
end
