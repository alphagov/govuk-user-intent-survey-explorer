class PhraseUsageController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @presenter = PhraseUsagePresenter.new(survey_answers_containing_phrase, search_params)
  end

private

  def survey_answers_containing_phrase
    SurveyAnswer.find_by_sql(["select * from survey_answers sa join questions q on q.id = sa.question_id join survey_phrases sp on sp.survey_answer_id = sa.id join phrases p on p.id = sp.phrase_id where p.id = ? and q.question_number = 3 and sa.answer not like '-'", "#{params[:id]}"])
  end

  def search_params
    @search_params ||= begin
      { page: 1 }.merge(
        params.permit(
          :page,
        ).to_h.symbolize_keys
      )
    end
  end
end
