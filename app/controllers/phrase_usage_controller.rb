class PhraseUsageController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @survey_answers_containing_phrase = SurveyAnswer.find_by_sql(["select * from survey_answers sa join questions q on q.id = sa.question_id join survey_phrases sp on sp.survey_answer_id = sa.id join phrases p on p.id = sp.phrase_id where p.id = ? and q.question_number = 3 and sa.answer not like '-' limit 10", "#{params[:id]}"])
  end
end
