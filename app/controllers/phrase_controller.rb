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
    @total_mentions = @mentions.inject(0){|sum, mention| sum + mention.total_mentions}
  end

private

  def pages_visited
    Page.find_by_sql("select pages.id, pages.base_path, count(pv.visit_id) as total_pageviews from survey_phrases m join phrases on phrases.id = m.phrase_id join survey_answers sa on sa.id = m.survey_answer_id join surveys s on s.id = sa.survey_id join visits v on v.visitor_id = s.visitor_id join page_visits pv on pv.visit_id = v.id join pages on pages.id = pv.page_id where phrases.id = #{@phrase.id} group by (pages.id) order by total_pageviews desc;")
  end

  def mentions
    SurveyAnswer.find_by_sql(['select date(s.started_at) as date, count(m.id) as total_mentions from survey_phrases m join phrases p on p.id = m.phrase_id join survey_answers sa on sa.id = m.survey_answer_id join surveys s on s.id = sa.survey_id where p.id = ? group by(date(s.started_at)) limit 10;', @phrase.id])
  end
end
