class PagesController < ApplicationController
  def show
    @page = Page.find(params[:id])
    surveys = Survey.where(full_path: @page.base_path)
    @survey_count = surveys.count
    @answers_by_question = surveys.each_with_object(Hash.new { |h, k| h[k] = [] }) do |survey, grouped_answers|
      survey.survey_answers.each do |survey_answer|
        grouped_answers[survey_answer.question] << survey_answer
      end
    end
  end
end
