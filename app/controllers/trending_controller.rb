class TrendingController < ApplicationController
  def index
    @top_pages = top_pages
    @trending_phrases = trending_phrases
    @trending_tags = trending_tags
    @trending_user_groups = trending_user_groups
  end

private

  def top_pages
    Page.find_by_sql('select pages.*, count(page_visits.visit_id) as total_pageviews from pages join page_visits on page_visits.page_id = pages.id group by pages.id limit 10')
  end

  def trending_phrases
    Phrase.limit(10)
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
