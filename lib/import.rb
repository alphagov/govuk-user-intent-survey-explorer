require "csv"

class Import
  attr_reader :channels, :devices, :questions

  def header_fields
    [
      "ga_primary_key",
      "intents_client_id",
      "started_at",
      "ended_at",
      "not_used_q4",
      "not_used_q5",
      "channel",
      "device_category",
      "full_visitor_id",
      "visit_id",
      "ga_visit_number",
      "ga_client_id", # not used at the moment
      "not_used_ga_visit_start_time",
      "not_used_ga_visit_end_time",
      "not_used_intents_started_date",
      "not_used_ga_date",
      "events_sequence",
      "pages_sequence",
      "search_terms_sequence",
      "not_used_flag_for_criteria",
      "not_used_full_url_in_session", # not currently used. when == 1 it means this session initiatied the survey
      "not_used_user_id",
      "not_used_user_no",
      "not_used_tracking_link",
      "not_used_page_path",
      "not_used_client_id",
      "q1_answer",
      "q4_answer",
      "q5_answer",
      "q6_answer",
      "not_used_target",
      "not_used_respondent_id",
      "full_url",
      "not_used_page",
      "section",
      "org",
      "not_used_started_date",
      "not_used_ended_date",
      "not_used_started_data_sub_12h",
      "q2_answer",
      "q3_answer",
      "q7_answer",
      "q8_answer",

    ]
  end

  def initialize
    @devices ||= Device.all.index_by {|d| d.name.downcase}
    @channels ||= Channel.all.index_by {|c| c.name.downcase}
    @questions ||= Question.all
  end

  def channel(search_term)
    # hard coded a "not specified" for when the channel is blank - a bit ugly, but it works
    return @channels["not specified"] if search_term.blank?
    raise "\"#{search_term}\" does not exist in the channels table" if @channels[search_term.downcase].nil?
    @channels[search_term.downcase]
  end

  def device(search_term)
    # hard coded a "not specified" for when the device is blank - a bit ugly, but it works
    return @devices["not specified"] if search_term.blank?
    raise "\"#{search_term}\" does not exist in the devices table" if @devices[search_term.downcase].nil?
    @devices[search_term.downcase]
  end

  def call
    CSV.foreach("tmp/data.csv", {headers: header_fields, header_converters: [:symbol]}) do |row|
      # I haven't figured out a way to skip the header row when passing an array
      # to headers in CSV.foreach. If we pass `headers: true`, it skips, but with an
      # array, it returns the header row as part of the result set.
      # So, manually skip the first row until we figure out something more elegant
      next if row[:ga_primary_key] == "primary_key"
      visit = insert_visit(row)
      survey = insert_survey(row, visit)
      insert_survey_answers(row, survey)
      insert_page_visits(row, visit)
      insert_search_visits(row, visit)
      insert_event_visits(row, visit)
    end

    puts %(Record summary:
      Event: #{Event.count}
      EventVisit: #{EventVisit.count}
      Page: #{Page.count}
      PageVisit: #{PageVisit.count}
      Search: #{Search.count}
      SearchVisit: #{SearchVisit.count}
      Survey: #{Survey.count}
      SurveyAnswer: #{SurveyAnswer.count}
      Visit: #{Visit.count}
      Visitor: #{Visitor.count}
    )
  end

  def upsert_visitor(row)
    Visitor.find_or_create_by(
      intent_client_id: row[:intents_client_id],
      ga_primary_key: row[:ga_primary_key],
      ga_full_visitor_id: row[:visitor_id],
    )
  end

  def insert_visit(row)
    visitor = upsert_visitor(row)

    device = device(row[:device_category])
    channel = channel(row[:channel])

    Visit.create(
      visitor: visitor,
      device: device,
      channel: channel,
      ga_visit_id: row[:visit_id],
      ga_visit_number: row[:ga_visit_number],
      ga_visit_start_at: row[:started_at],
      ga_visit_end_at: row[:ended_at],
    )
  end

  def upsert_organisation(row)
    Organisation.find_or_create_by(
      name: row[:org] || "Not specified"
    )
  end

  def insert_survey(row, visit)
    organisation = upsert_organisation(row)

    Survey.create(
      organisation_id: organisation.id,
      visitor_id: visit.visitor_id,
      ga_primary_key: row[:ga_primary_key],
      intents_client_id: row[:intents_client_id],
      started_at: row[:started_at],
      ended_at: row[:ended_at],
      full_path: row[:pages_sequence],
      section: row[:section]
    )
  end

  def insert_survey_answers(row, survey)
    questions.each do |question|
      answer_row_header = "q#{question.question_number}_answer"
      SurveyAnswer.create(
        survey_id: survey.id,
        question_id: question.id,
        answer: row[answer_row_header]
      )
    end
  end

  def upsert_page(page_base_path)
    Page.find_or_create_by(
      base_path: page_base_path
    )
  end

  def insert_page_visits(row, visit)
    unless row[:pages_sequence].nil?
      pages = row[:pages_sequence].split(', ')

      pages.each_with_index do |page_base_path, i|
        page = upsert_page(page_base_path)

        PageVisit.create(
          page_id: page.id,
          visit_id: visit.id,
          sequence: i + 1
        )
      end
    end
  end

  def upsert_search(search)
    Search.find_or_create_by(
      search_string: search
    )
  end

  def insert_search_visits(row, visit)
    unless row[:search_terms_sequence].nil?
      searches = row[:search_terms_sequence].split(', ')

      searches.each_with_index do |search, i|
        search = upsert_search(search)

        SearchVisit.create(
          search_id: search.id,
          visit_id: visit.id,
          sequence: i + 1
        )
      end
    end
  end

  def upsert_event(event_name_action)
    Event.find_or_create_by(
     name: event_name_action
    )
  end

  def insert_event_visits(row, visit)
    unless row[:events_sequence].nil?
      events = row[:events_sequence].split(', ')

      events.each_with_index do |event_name_action, i|
        event = upsert_event(event_name_action)

        EventVisit.create(
         event_id: event.id,
         visit_id: visit.id,
         sequence: i + 1
        )
      end
    end
  end
end
