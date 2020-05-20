require "spec_helper"

RSpec.feature "phrase page" do
  before :each do
    visitor = FactoryBot.create(:visitor)
    survey1 = FactoryBot.create(:survey, started_at: DateTime.now - 6.days, visitor: visitor)
    survey2 = FactoryBot.create(:survey, started_at: DateTime.now - 5.days, visitor: visitor)

    @phrase = FactoryBot.create(:phrase, phrase_text: "how government works")
    @survey_answer1 = FactoryBot.create(:survey_answer, survey: survey1, answer: "I want to understand how government works")
    @survey_answer2 = FactoryBot.create(:survey_answer, survey: survey2, answer: "How government works is important")

    FactoryBot.create(:mention, phrase: @phrase, survey_answer: @survey_answer1)
    FactoryBot.create(:mention, phrase: @phrase, survey_answer: @survey_answer2)

    top_page = FactoryBot.create(:page, base_path: "/about-government")
    device = FactoryBot.create(:device, name: "Desktop")
    user_visit = FactoryBot.create(:visit, visitor: visitor, device: device)
    FactoryBot.create(:survey_visit, survey: survey1, visit: user_visit)
    FactoryBot.create(:page_visit, page: top_page, visit: user_visit)
  end

  scenario "displays mentions overview data" do
    visit phrase_path(@phrase)
    expect(page).to have_content("'how government works'")
    expect(page).to have_css(".statistic-total", text: 2)
  end

  scenario "displays top page links" do
    visit phrase_path(@phrase)

    expect(page).to have_link("/about-government")
  end

  scenario "displays device data breakdown" do
    visit phrase_path(@phrase)

    expect(page).to have_css(".table-group", text: "Desktop 100%")
  end

  scenario "displays examples of phrase mentions" do
    visit phrase_path(@phrase)

    expect(page).to have_content(@survey_answer1.answer)
    expect(page).to have_content(@survey_answer2.answer)
  end
end
