class NumberOfMentionsController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @mentions = SurveyAnswer.find_by_sql(['select date(s.started_at) as date, count(m.id) as total_mentions from survey_phrases m join phrases p on p.id = m.phrase_id join survey_answers sa on sa.id = m.survey_answer_id join surveys s on s.id = sa.survey_id where p.id = ? group by(date(s.started_at)) limit 10;', @phrase.id])
    @total_mentions = @mentions.inject(0){|sum, mention| sum + mention.total_mentions}
  end
end
