require "spec_helper"
require_relative "../spec_helpers/phrase_helper"

RSpec.describe Page, type: :model do
  describe "unique visitors for phrase" do
    context "with empty database" do
      it "returns an empty array when no data exists" do
        phrase = FactoryBot.build(:phrase)
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = Page.unique_visitors_for_phrase(phrase, start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      before :each do
        @phrase = FactoryBot.create(:phrase)
        @visitor = FactoryBot.create(:visitor)
        page1 = FactoryBot.create(:page, base_path: "/about-government")
        page2 = FactoryBot.create(:page, base_path: "/government-departments")
        page3 = FactoryBot.create(:page, base_path: "/overseas-offices")
        page4 = FactoryBot.create(:page, base_path: "/crown-dependencies")

        create_surveys_for_page(page1, "2020-03-20", 3)
        create_surveys_for_page(page1, "2020-03-21", 1)
        create_surveys_for_page(page2, "2020-03-21", 5)
        create_surveys_for_page(page3, "2020-03-22", 8)
        create_surveys_for_page(page4, "2020-03-22", 2)

        phrase2 = FactoryBot.create(:phrase)
        create_surveys_for_page(page4, "2020-03-20", 6, phrase: phrase2)
      end

      it "returns an empty array when date range matches no data" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = Page.unique_visitors_for_phrase(@phrase, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns page data for phrase when date range matches data" do
        start_date = Date.new(2020, 3, 18)
        end_date = Date.new(2020, 3, 21)

        result = Page.unique_visitors_for_phrase(@phrase, start_date, end_date)

        expect(result).to eq([["/about-government", 2], ["/government-departments", 1]])
      end

      it "returns ordered page data for phrase by key and default direction when key is specified and direction is not" do
        additional_page = FactoryBot.create(:page, base_path: "/what-government-does")
        create_surveys_for_page(additional_page, "2020-03-19", 2)
        create_surveys_for_page(additional_page, "2020-03-20", 2)
        create_surveys_for_page(additional_page, "2020-03-21", 2)

        start_date = Date.new(2020, 3, 18)
        end_date = Date.new(2020, 3, 21)

        result = Page.unique_visitors_for_phrase(@phrase, start_date, end_date, sort_key: "base_path")

        expect(result).to eq([["/what-government-does", 3], ["/government-departments", 1], ["/about-government", 2]])
      end

      it "returns ordered page data for phrase by direction and default key when direction is specified and key is not" do
        additional_page = FactoryBot.create(:page, base_path: "/find-help")
        create_surveys_for_page(additional_page, "2020-03-20", 2)

        start_date = Date.new(2020, 3, 18)
        end_date = Date.new(2020, 3, 21)

        result = Page.unique_visitors_for_phrase(@phrase, start_date, end_date, sort_dir: "asc")

        expect(result).to eq([["/government-departments", 1], ["/find-help", 1], ["/about-government", 2]])
      end

      it "returns ordered page data for phrase by both key and direction when key and direction are specified" do
        home_page = FactoryBot.create(:page, base_path: "/")
        help_page = FactoryBot.create(:page, base_path: "/find-help")
        create_surveys_for_page(home_page, "2020-03-21", 10)
        create_surveys_for_page(help_page, "2020-03-20", 2)

        start_date = Date.new(2020, 3, 18)
        end_date = Date.new(2020, 3, 21)

        result = Page.unique_visitors_for_phrase(@phrase, start_date, end_date, sort_key: "base_path", sort_dir: "asc")

        expect(result).to eq([["/", 1], ["/about-government", 2], ["/find-help", 1], ["/government-departments", 1]])
      end
    end
  end

  describe "total visitors for phrase" do
    context "with empty database" do
      it "returns an empty array when no data exists" do
        phrase = FactoryBot.build(:phrase)
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = Page.total_visitors_for_phrase(phrase, start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      before :each do
        @phrase = FactoryBot.create(:phrase)
        @visitor = FactoryBot.create(:visitor)
        page1 = FactoryBot.create(:page, base_path: "/about-government")
        page2 = FactoryBot.create(:page, base_path: "/government-departments")
        page3 = FactoryBot.create(:page, base_path: "/overseas-offices")
        page4 = FactoryBot.create(:page, base_path: "/crown-dependencies")

        create_surveys_for_page(page1, "2020-03-20", 3, unique_visits: false)
        create_surveys_for_page(page1, "2020-03-21", 1, unique_visits: false)
        create_surveys_for_page(page2, "2020-03-21", 5, unique_visits: false)
        create_surveys_for_page(page3, "2020-03-22", 8, unique_visits: false)
        create_surveys_for_page(page4, "2020-03-22", 2, unique_visits: false)
      end

      it "returns an empty array when date range matches no data" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = Page.total_visitors_for_phrase(@phrase, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns page data for phrase when date range matches data" do
        start_date = Date.new(2020, 3, 18)
        end_date = Date.new(2020, 3, 21)

        result = Page.total_visitors_for_phrase(@phrase, start_date, end_date)

        expect(result).to eq([["/government-departments", 5], ["/about-government", 4]])
      end

      it "returns ordered page data for phrase by key and default direction when key is specified and direction is not" do
        additional_page = FactoryBot.create(:page, base_path: "/what-government-does")
        create_surveys_for_page(additional_page, "2020-03-20", 2, unique_visits: false)

        start_date = Date.new(2020, 3, 18)
        end_date = Date.new(2020, 3, 21)

        result = Page.total_visitors_for_phrase(@phrase, start_date, end_date, sort_key: "base_path")

        expect(result).to eq([["/what-government-does", 2], ["/government-departments", 5], ["/about-government", 4]])
      end

      it "returns ordered page data for phrase by direction and default key when direction is specified and key is not" do
        additional_page = FactoryBot.create(:page, base_path: "/find-help")
        create_surveys_for_page(additional_page, "2020-03-20", 2, unique_visits: false)

        start_date = Date.new(2020, 3, 18)
        end_date = Date.new(2020, 3, 21)

        result = Page.total_visitors_for_phrase(@phrase, start_date, end_date, sort_dir: "asc")

        expect(result).to eq([["/find-help", 2], ["/about-government", 4], ["/government-departments", 5]])
      end

      it "returns ordered page data for phrase by both key and direction when key and direction are specified" do
        home_page = FactoryBot.create(:page, base_path: "/")
        help_page = FactoryBot.create(:page, base_path: "/find-help")
        create_surveys_for_page(home_page, "2020-03-21", 10, unique_visits: false)
        create_surveys_for_page(help_page, "2020-03-20", 2, unique_visits: false)

        start_date = Date.new(2020, 3, 18)
        end_date = Date.new(2020, 3, 21)

        result = Page.total_visitors_for_phrase(@phrase, start_date, end_date, sort_key: "base_path", sort_dir: "asc")

        expect(result).to eq([["/", 10], ["/about-government", 4], ["/find-help", 2], ["/government-departments", 5]])
      end
    end
  end

  describe "top pages" do
    context "with empty database" do
      it "returns no top pages" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 20)

        result = Page.top_pages(start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns no top pages when date filter matches no surveys" do
        survey = FactoryBot.create(:survey, started_at: "2020-03-05")
        visit = FactoryBot.create(:visit)
        FactoryBot.create(:survey_visit, survey: survey, visit: visit)
        top_pages = FactoryBot.create_list(:page, 10)
        top_pages.each do |page|
          FactoryBot.create(:page_visit, page: page, visit: visit)
        end

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 20)

        result = Page.top_pages(start_date, end_date)

        expect(result).to be_empty
      end

      it "returns top pages when date filter matches surveys" do
        survey = FactoryBot.create(:survey, started_at: "2020-03-05")
        visit = FactoryBot.create(:visit)
        FactoryBot.create(:survey_visit, survey: survey, visit: visit)
        top_pages = FactoryBot.create_list(:page, 20)
        top_pages.each do |page|
          FactoryBot.create(:page_visit, page: page, visit: visit)
        end

        start_date = Date.new(2020, 3, 2)
        end_date = Date.new(2020, 3, 20)

        result = Page.top_pages(start_date, end_date)

        expect(result.count).to eq(20)
        expect(page_base_path(result.first)).to eq(top_pages.first.base_path)
        expect(page_total_pageviews(result.first)).to eq(1)
      end
    end
  end

  describe "search_by_base_path" do
    context "with empty database" do
      it "returns no pages" do
        start_date = Date.new(2020, 3, 2)
        end_date = Date.new(2020, 3, 20)
        options = { sort_key: "feedback_comments", sort_dir: "desc" }
        result = Page.search_by_base_path("", start_date, end_date, options)
        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns top phrases in order of number of mentions in descending order" do
        phrase = FactoryBot.create(:phrase)
        generic_phrase = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase, generic_phrase)

        start_date, end_date = default_dates
        page1, page2 = create_pages_with_multiple_surveys(start_date, phrase: phrase)
        options = { sort_key: "feedback_comments", sort_dir: "desc" }

        result = Page.search_by_base_path("", start_date, end_date, options)

        expected_result = [
          {
            base_path: "/council-of-ricks/minutes",
            page_id: page2.id,
            survey_count: 2,
          },
          {
            base_path: "/get-your-interdimensional-tv-licence",
            page_id: page1.id,
            survey_count: 1,
          },
        ]
        expect(result).to eq(expected_result)
      end

      it "returns top phrases in order of number of mentions in ascending order" do
        phrase = FactoryBot.create(:phrase)
        generic_phrase = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase, generic_phrase)

        start_date, end_date = default_dates
        page1, page2 = create_pages_with_multiple_surveys(start_date, phrase: phrase)
        options = { sort_key: "feedback_comments", sort_dir: "asc" }

        result = Page.search_by_base_path("", start_date, end_date, options)

        expected_result = [
          {
            base_path: "/get-your-interdimensional-tv-licence",
            page_id: page1.id,
            survey_count: 1,
          },
          {
            base_path: "/council-of-ricks/minutes",
            page_id: page2.id,
            survey_count: 2,
          },
        ]
        expect(result).to eq(expected_result)
      end

      it "returns top phrases in order of base path descending order" do
        phrase = FactoryBot.create(:phrase)
        generic_phrase = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase, generic_phrase)

        start_date, end_date = default_dates
        page1, page2 = create_pages_with_multiple_surveys(start_date, phrase: phrase)
        options = { sort_key: "page_base_path", sort_dir: "desc" }

        result = Page.search_by_base_path("", start_date, end_date, options)

        expected_result = [
          {
            base_path: "/get-your-interdimensional-tv-licence",
            page_id: page1.id,
            survey_count: 1,
          },
          {
            base_path: "/council-of-ricks/minutes",
            page_id: page2.id,
            survey_count: 2,
          },
        ]
        expect(result).to eq(expected_result)
      end

      it "returns top pages in order of base path in ascending order" do
        phrase = FactoryBot.create(:phrase)
        generic_phrase = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase, generic_phrase)

        start_date, end_date = default_dates
        page1, page2 = create_pages_with_multiple_surveys(start_date, phrase: phrase)
        options = { sort_key: "page_base_path", sort_dir: "asc" }

        result = Page.search_by_base_path("", start_date, end_date, options)

        expected_result = [
          {
            base_path: "/council-of-ricks/minutes",
            page_id: page2.id,
            survey_count: 2,
          },
          {
            base_path: "/get-your-interdimensional-tv-licence",
            page_id: page1.id,
            survey_count: 1,
          },
        ]
        expect(result).to eq(expected_result)
      end

      it "returns no pages when date filter matches no surveys" do
        start_date, end_date = default_dates
        create_pages_with_multiple_surveys(end_date + 1.day)
        options = { sort_key: "feedback_comments", sort_dir: "desc" }

        result = Page.search_by_base_path("", start_date, end_date, options)
        expect(result).to be_empty
      end

      it "returns no pages when verb filter doesn't match associated generic phrases" do
        phrase = FactoryBot.create(:phrase)
        generic_phrase = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase, generic_phrase)

        start_date, end_date = default_dates
        create_pages_with_multiple_surveys(start_date, phrase: phrase)
        options = { sort_key: "feedback_comments", sort_dir: "desc", verb: "does-not-exist" }

        result = Page.search_by_base_path("interdimensional-tv", start_date, end_date, options)

        expect(result).to be_empty
      end

      it "returns no pages when adjective filter doesn't match associated generic phrases" do
        phrase = FactoryBot.create(:phrase)
        generic_phrase = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase, generic_phrase)

        start_date, end_date = default_dates
        create_pages_with_multiple_surveys(start_date, phrase: phrase)
        options = { sort_key: "feedback_comments", sort_dir: "desc", adjective: "does-not-exist" }

        result = Page.search_by_base_path("interdimensional-tv", start_date, end_date, options)

        expect(result).to be_empty
      end

      it "returns pages when date range matches surveys and base path matches pages" do
        phrase = FactoryBot.create(:phrase)
        generic_phrase = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase, generic_phrase)

        start_date, end_date = default_dates
        page1, _page2 = create_pages_with_multiple_surveys(start_date, phrase: phrase)
        options = { sort_key: "feedback_comments", sort_dir: "desc" }

        result = Page.search_by_base_path("interdimensional-tv", start_date, end_date, options)
        expected_resut = [
          {
            base_path: "/get-your-interdimensional-tv-licence",
            page_id: page1.id,
            survey_count: 1,
          },
        ]
        expect(result).to eq(expected_resut)
      end

      it "returns pages when verb filer matches associated generic phrases" do
        phrase1 = FactoryBot.create(:phrase)
        generic_phrase1 = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase1, generic_phrase1)

        phrase2 = FactoryBot.create(:phrase)
        generic_phrase2 = create_generic_phrase_for_verb_adjective("find", "help")
        associate_phrase_with_generic_phrase(phrase2, generic_phrase2)

        start_date, end_date = default_dates
        page1, page2 = create_pages_with_multiple_surveys(start_date, phrase: phrase1)
        _page3, _page4 = create_pages_with_multiple_surveys(end_date, page1_path: "/find-tv-license", page2_path: "/interdimensional-rules", phrase: phrase2)

        options = { sort_key: "feedback_comments", sort_dir: "desc", verb: "pay" }

        result = Page.search_by_base_path("", start_date, end_date, options)

        expected_result = [
          {
            base_path: "/council-of-ricks/minutes",
            page_id: page2.id,
            survey_count: 2,
          },
          {
            base_path: "/get-your-interdimensional-tv-licence",
            page_id: page1.id,
            survey_count: 1,
          },
        ]

        expect(result.count).to eq(2)
        expect(result).to eq(expected_result)
      end

      it "returns pages when adjective filter matches associated generic phrases" do
        phrase1 = FactoryBot.create(:phrase)
        generic_phrase1 = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase1, generic_phrase1)

        phrase2 = FactoryBot.create(:phrase)
        generic_phrase2 = create_generic_phrase_for_verb_adjective("find", "help")
        associate_phrase_with_generic_phrase(phrase2, generic_phrase2)

        start_date, end_date = default_dates
        _page1, _page2 = create_pages_with_multiple_surveys(start_date, phrase: phrase1)
        page3, page4 = create_pages_with_multiple_surveys(end_date, page1_path: "/find-tv-license", page2_path: "/interdimensional-rules", phrase: phrase2)

        options = { sort_key: "feedback_comments", sort_dir: "desc", adjective: "help" }

        result = Page.search_by_base_path("", start_date, end_date, options)

        expected_result = [
          {
            base_path: "/interdimensional-rules",
            page_id: page4.id,
            survey_count: 2,
          },
          {
            base_path: "/find-tv-license",
            page_id: page3.id,
            survey_count: 1,
          },
        ]

        expect(result.count).to eq(2)
        expect(result).to eq(expected_result)
      end

      it "returns pages when verb and adjective filters matches associated generic phrases" do
        phrase1 = FactoryBot.create(:phrase)
        generic_phrase1 = create_generic_phrase_for_verb_adjective("pay", "bills")
        associate_phrase_with_generic_phrase(phrase1, generic_phrase1)

        phrase2 = FactoryBot.create(:phrase)
        generic_phrase2 = create_generic_phrase_for_verb_adjective("find", "help")
        associate_phrase_with_generic_phrase(phrase2, generic_phrase2)

        phrase3 = FactoryBot.create(:phrase)
        generic_phrase3 = create_generic_phrase_for_verb_adjective("pay", "fine")
        associate_phrase_with_generic_phrase(phrase3, generic_phrase3)

        start_date, end_date = default_dates
        _page1, _page2 = create_pages_with_multiple_surveys(start_date, phrase: phrase1)
        _page3, _page4 = create_pages_with_multiple_surveys(end_date, phrase: phrase2)
        page5, page6 = create_pages_with_multiple_surveys(start_date, page1_path: "/find-tv-license", page2_path: "/interdimensional-rules", phrase: phrase3)

        options = { sort_key: "feedback_comments", sort_dir: "desc", verb: "pay", adjective: "fine" }

        result = Page.search_by_base_path("", start_date, end_date, options)

        expected_result = [
          {
            base_path: "/interdimensional-rules",
            page_id: page6.id,
            survey_count: 2,
          },
          {
            base_path: "/find-tv-license",
            page_id: page5.id,
            survey_count: 1,
          },
        ]

        expect(result.count).to eq(2)
        expect(result).to eq(expected_result)
      end
    end
  end

  # TODO: Write spec for top_visits_last_page
  # TODO: Write spec for top_visits_next_page
end

def page_base_path(result)
  result[0]
end

def page_total_pageviews(result)
  result[1]
end

def create_surveys_for_page(page, survey_started_at, number_of_visits, phrase: @phrase, unique_visits: true)
  survey = FactoryBot.create(:survey, started_at: survey_started_at)
  survey_answer = FactoryBot.create(:survey_answer, survey: survey)
  FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)

  visits = unique_visits ? [FactoryBot.create(:visit, visitor: @visitor)] * number_of_visits : FactoryBot.create_list(:visit, number_of_visits, visitor: @visitor)

  visits.each do |visit|
    FactoryBot.create(:page_visit, page: page, visit: visit)
    FactoryBot.create(:survey_visit, survey: survey, visit: visit)
  end
end

def default_dates
  start_date = Date.new(2020, 3, 10)
  end_date = Date.new(2020, 3, 20)
  [start_date, end_date]
end

def create_pages_with_multiple_surveys(start_date, page1_path: "/get-your-interdimensional-tv-licence", page2_path: "/council-of-ricks/minutes", phrase: FactoryBot.create(:phrase))
  visitor = FactoryBot.create(:visitor)
  page1 = FactoryBot.create(:page, base_path: page1_path)
  page2 = FactoryBot.create(:page, base_path: page2_path)

  [page1, page2].each_with_index do |page, index|
    survey_count = index + 1
    survey_count.times do
      survey = FactoryBot.create(:survey, started_at: start_date)
      survey_answer = FactoryBot.create(:survey_answer, survey: survey)
      FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)
      visit = FactoryBot.create(:visit, visitor: visitor)
      FactoryBot.create(:page_visit, page: page, visit: visit)
      FactoryBot.create(:survey_visit, survey: survey, visit: visit)
    end
  end

  [page1, page2]
end

def create_generic_phrase_for_verb_adjective(verb_text, adjective_text)
  verb = FactoryBot.create(:verb, name: verb_text)
  adjective = FactoryBot.create(:adjective, name: adjective_text)

  FactoryBot.create(:generic_phrase, verb: verb, adjective: adjective)
end
