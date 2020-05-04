require "spec_helper"

RSpec.feature "pages visited" do
  scenario "displays pages visited" do
    visitor = FactoryBot.create(:visitor)
    survey = FactoryBot.create(:survey, started_at: "2020-04-02 00:00:00", visitor: visitor)

    phrase = FactoryBot.create(:phrase, phrase_text: "how government works")
    survey_answer = FactoryBot.create(:survey_answer, survey: survey)
    FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)

    user_visit1 = FactoryBot.create(:visit, visitor: visitor)
    user_visit2 = FactoryBot.create(:visit, visitor: visitor)
    FactoryBot.create(:survey_visit, survey: survey, visit: user_visit1)
    FactoryBot.create(:survey_visit, survey: survey, visit: user_visit2)

    create_pages_and_page_visits_for_visit(10, user_visit1)
    create_pages_and_page_visits_for_visit(10, user_visit2)

    visit pages_visited_path(phrase)

    expect(page).to have_link("/test-page-1")
    expect(page).to have_link("/test-page-15")
    expect(page).to have_content("Next page")
  end
end

def create_pages_and_page_visits_for_visit(number_of_pages, visit)
  pages = FactoryBot.create_list(:page, number_of_pages)
  pages.each { |page| FactoryBot.create(:page_visit, page: page, visit: visit) }
end
