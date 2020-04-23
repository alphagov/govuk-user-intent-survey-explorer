class TrendingController < ApplicationController
  def index
    @top_pages = top_pages
    @trending_phrases = trending_phrases
    @trending_tags = trending_tags
    @trending_user_groups = trending_user_groups
  end

private

  def top_pages
    Page.find_by_sql('select pages.*, count(page_visits.visit_id) as total_pageviews, concat(\'https://www.gov.uk\', pages.base_path) as govuk_link from pages join page_visits on page_visits.page_id = pages.id group by pages.id limit 10')
  end

  def trending_phrases
    Phrase.find_by_sql('select count(m.phrase_id) as mentions, phrases.id, phrases.phrase_text from phrases join survey_phrases m on m.phrase_id = phrases.id join survey_answers sa on sa.id = m.survey_answer_id join surveys s on s.id = sa.survey_id group by (m.phrase_id, phrases.id, phrases.phrase_text) order by mentions desc limit 10')
  end

  def trending_tags
    [
      { text: 'Food & deliveries', link: '#'},
      { text: 'Vulnerable', link: '#'},
      { text: 'Business loans', link: '#'},
      { text: 'Isolation & quarantine', link: '#'},
      { text: 'Lockdown & rules', link: '#'},
      { text: 'Health/social care - staff', link: '#'},
      { text: 'Travel & transport - UK', link: '#'},
      { text: 'Livelihood - employee', link: '#'},
      { text: 'Education & nursery', link: '#'},
      { text: 'Profiteering', link: '#'}
    ]
  end

  def trending_user_groups
    [
      { text: 'self', link: '#'},
      { text: 'a key worker', link: '#'},
      { text: 'a vulnerable person', link: '#'},
      { text: 'high risk', link: '#'},
      { text: 'wife', link: '#'},
      { text: 'a carer', link: '#'},
      { text: 'a pensioner', link: '#'},
      { text: '75 years', link: '#'},
      { text: 'type 1', link: '#'},
      { text: 'a teacher', link: '#'}
    ]
  end
end
