class PhraseController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @devices_used = [
      { device_type: 'Desktop', percentage_use: 0.35 },
      { device_type: 'Mobile', percentage_use: 0.6 },
      { device_type: 'Tablet', percentage_use: 0.04 }
    ]

    @pages_visited = pages_visited
    @mentions = mentions
    @survey_answers_containing_phrase = SurveyAnswer.find_by_sql(["select * from survey_answers sa join questions q on q.id = sa.question_id join survey_phrases sp on sp.survey_answer_id = sa.id join phrases p on p.id = sp.phrase_id where p.id = ? and q.question_number = 3 and sa.answer not like '-' limit 10", "#{@phrase.id}"])
  end

private

  def pages_visited
    Page.find_by_sql("select pages.id, pages.base_path, count(pv.visit_id) as total_pageviews from survey_phrases m join phrases on phrases.id = m.phrase_id join survey_answers sa on sa.id = m.survey_answer_id join surveys s on s.id = sa.survey_id join visits v on v.visitor_id = s.visitor_id join page_visits pv on pv.visit_id = v.id join pages on pages.id = pv.page_id where phrases.id = #{@phrase.id} group by (pages.id) order by total_pageviews desc;")
  end

  def mentions
    SurveyPhrase
      .mentions_by_date_range_for_phrase(@phrase, Date.new(2020, 4, 1), Date.new(2020, 4, 7))
      .sort_by{ |date, _| date }
      .to_h
  end
end
