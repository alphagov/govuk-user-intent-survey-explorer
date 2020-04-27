require 'spec_helper'

RSpec.feature 'pages visited' do
  scenario 'displays pages visited' do
    visitor = FactoryBot.create(:visitor)
    survey1 = FactoryBot.create(:survey, started_at: '2020-04-02 00:00:00', visitor: visitor)
    survey2 = FactoryBot.create(:survey, started_at: '2020-04-03 00:00:00', visitor: visitor)

    @phrase = FactoryBot.create(:phrase, phrase_text: 'how government works')
    @survey_answer1 = FactoryBot.create(:survey_answer, survey: survey1, answer: 'I want to understand how government works')
    @survey_answer2 = FactoryBot.create(:survey_answer, survey: survey2, answer: 'How government works is important')

    FactoryBot.create(:survey_phrase, phrase: @phrase, survey_answer: @survey_answer1)
    FactoryBot.create(:survey_phrase, phrase: @phrase, survey_answer: @survey_answer2)

    user_visit = FactoryBot.create(:visit, visitor: visitor)
    pages = FactoryBot.create_list(:page, 20)
    pages.each {|p| FactoryBot.create(:page_visit, page: p, visit: user_visit) }

    visit pages_visited_path(@phrase)

    expect(page).to have_link("/test-page-1")
    expect(page).to have_link("/test-page-15")
    expect(page).to have_content("Next page")
  end
end