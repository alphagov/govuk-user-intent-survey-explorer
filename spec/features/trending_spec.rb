require 'spec_helper'

RSpec.feature 'trend page' do
  before(:each) do
    @top_page = FactoryBot.create(:page, base_path: '/department-of-wizards')
    @page_visit = FactoryBot.create(:page_visit, page: @top_page)

    @phrase = FactoryBot.create(:phrase, phrase_text: 'abra cadabra')
    @survey_answer = FactoryBot.create(:survey_answer, answer: 'I wanted to say abra cadabra and find what I was looking for')
    @survey_phrase = FactoryBot.create(:survey_phrase, phrase: @phrase, survey_answer: @survey_answer)
    @user_group = FactoryBot.create(:user_group, group: 'Over 40')
    @survey = FactoryBot.create(:survey, started_at: '2020-04-02 00:00:00')
    @survey_user_group = FactoryBot.create(:survey_user_group, survey: @survey, user_group: @user_group)
  end

  scenario 'displays overview of trending data' do
    visit '/'

    expect(page).to have_content('User intent survey data')
    expect(page).to have_link(@top_page.base_path, href: "https://www.gov.uk#{@top_page.base_path}")
    expect(page).to have_link(@phrase.phrase_text)
    expect(page).to have_content(@user_group.group)
  end
end
