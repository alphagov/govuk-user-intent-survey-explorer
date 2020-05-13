require "spec_helper"
require_relative "../spec_helpers/phrase_helper"

RSpec.feature "pages index" do
  scenario "shows phrases for pages" do
    pages = []
    pages << FactoryBot.create(:page, base_path: "/marry-a-birdperson-step-by-step")
    pages << FactoryBot.create(:page, base_path: "/get-your-interdimensional-tv-licence")
    pages << FactoryBot.create(:page, base_path: "/portal-gun-repairs")
    pages << FactoryBot.create(:page, base_path: "/council-of-ricks/minutes")

    stub_search_api(pages.map(&:base_path))
    stub_content_store_api("/portal-gun-repairs")

    start_date = DateTime.now - 1.day
    pages.each_with_index do |page, index|
      create_phrases_for_page(page, start_date, 3, index)
    end

    visit pages_path

    expect(page).to have_link("Step by step: marry a birdperson")
    expect(page).to have_link("Get your portal gun repaired")
    expect(page).to have_link("Get your interdimensional TV licence")
    expect(page).to have_link("Council of Ricks: Minutes")
    expect(page).to have_content("I need assistance 1")
    expect(page).to have_content("I need assistance 2")
    expect(page).to have_content("I need assistance 3")
    expect(page).to have_content("Showing 4 content pages where users have given survey answers")
    expect(page).to have_content("Next page")
  end
end

def stub_search_api(base_paths)
  # Search API doesn't index all documents, so it won't always return
  # a result for every base path we pass it.
  # Here, we intentionally leave out one of the results to test
  # that it then hits the Content Store API with the remaining
  # base path (as that is guaranteed to have the remaining page)
  results = {
    "results" => [
      {
          "link" => "/marry-a-birdperson-step-by-step",
          "title" => "Step by step: marry a birdperson",
      },
      {
          "link" => "/get-your-interdimensional-tv-licence",
          "title" => "Get your interdimensional TV licence",
      },
      {
          "link" => "/council-of-ricks/minutes",
          "title" => "Council of Ricks: Minutes",
      },
    ],
  }

  filters = {
    count: base_paths.count,
    filter_link: base_paths,
    fields: %i[link title],
  }
  GdsApi::Search.any_instance.stubs(:search).with(filters).returns(results)
end

def stub_content_store_api(base_path)
  result = { "title" => "Get your portal gun repaired" }
  GdsApi::ContentStore.any_instance.stubs(:content_item).with(base_path).returns(result)
end
