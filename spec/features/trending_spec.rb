require "spec_helper"

RSpec.feature "trend page" do
  before(:each) do
    @top_page = FactoryBot.create(:page)
    user_visit = FactoryBot.create(:visit)
    @page_visit = FactoryBot.create(:page_visit, page: @top_page, visit: user_visit)

    @phrase = FactoryBot.create(:phrase)
    @survey = FactoryBot.create(:survey, started_at: DateTime.now.strftime("%F"))
    @survey_answer = FactoryBot.create(:survey_answer, survey: @survey)
    FactoryBot.create(:mention, phrase: @phrase, survey_answer: @survey_answer)
    @user_group = FactoryBot.create(:user_group)
    FactoryBot.create(:survey_visit, survey: @survey, visit: user_visit)
    @survey_user_group = FactoryBot.create(:survey_user_group, survey: @survey, user_group: @user_group)
  end

  scenario "displays overview of trending data" do
    visit "/"

    expect(page).to have_content("Overview")
    expect(page).to have_link(@top_page.base_path, href: "https://www.gov.uk#{@top_page.base_path}")
    expect(page).to have_link(@phrase.phrase_text)
    expect(page).to have_content(@user_group.group)
  end
end
