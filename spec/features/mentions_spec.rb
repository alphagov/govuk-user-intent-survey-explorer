require "spec_helper"

RSpec.feature "mentions page" do
  before :each do
    @six_days_ago_date = DateTime.now - 6.days
    @five_days_ago_date = DateTime.now - 5.days

    visitor = FactoryBot.create(:visitor)
    survey1 = FactoryBot.create(:survey, started_at: @six_days_ago_date.strftime("%F"), visitor: visitor)
    survey2 = FactoryBot.create(:survey, started_at: @five_days_ago_date.strftime("%F"), visitor: visitor)

    @phrase = FactoryBot.create(:phrase, phrase_text: "how government works")
    @survey_answer1 = FactoryBot.create(:survey_answer, survey: survey1, answer: "I want to understand how government works")
    @survey_answer2 = FactoryBot.create(:survey_answer, survey: survey2, answer: "How government works is important")

    FactoryBot.create(:mention, phrase: @phrase, survey_answer: @survey_answer1)
    FactoryBot.create(:mention, phrase: @phrase, survey_answer: @survey_answer2)
  end

  scenario "displays total number of mentions" do
    visit_mentions_page

    expect(page).to have_css(".statistic-total", text: 2)
  end

  scenario "displays mentions breakdown as chart" do
    visit_mentions_page

    expect(page).to have_css("svg")
  end

  scenario "dispays mentions breakdown as table" do
    visit_mentions_page

    expect(page).to have_css(".table-group")
    expect(page).to have_content("#{@six_days_ago_date.strftime("#{@six_days_ago_date.day.ordinalize} %b %Y")} 1")
    expect(page).to have_content("#{@five_days_ago_date.strftime("#{@five_days_ago_date.day.ordinalize} %b %Y")} 1")
  end

  def visit_mentions_page
    visit mention_path(@phrase)
  end
end
