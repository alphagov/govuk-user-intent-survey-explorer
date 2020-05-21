require "spec_helper"

RSpec.feature "generic phrases" do
  scenario "displays generic phrases" do
    visit generic_phrases_path

    expect(page).to have_content "Generic phrase"
  end

  scenario "displays individual generic phrase" do
    phrase = FactoryBot.create(:phrase)
    generic_phrase = create_generic_phrase_model("pay", "bills")
    associate_phrase_with_generic_phrase(phrase, generic_phrase)

    create_survey_with_phrases("2020-03-10", phrases: [phrase])

    visit generic_phrase_path(generic_phrase)

    expect(page).to have_content("pay-bills")
    expect(page).to have_content("First appeared at\n10th March 2020")
  end
end
