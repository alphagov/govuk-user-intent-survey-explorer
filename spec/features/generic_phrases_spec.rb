require "spec_helper"

RSpec.feature "generic phrases" do
  scenario "displays generic phrases" do
    visit generic_phrases_path

    expect(page).to have_content "Generic phrase"
  end
end
