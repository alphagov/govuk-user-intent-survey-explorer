require "csv"

class Import
  attr_reader :channels, :devices, :questions

  def header_fields
    %w[
      ga_primary_key
      intents_client_id
      visit_id
      full_visitor_id
      not_used
      started_at
      ended_at
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      session_id
      day_of_week
      is_weekend
      hour
      country
      country_grouping
      UK_region
      UK_metro_area
      channel
      device_category
      total_seconds
      total_pageviews_in_session_across_days
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      done_page_flag
      count_client_error
      count_server_error
      not_used_ga_visit_start_time
      not_used_ga_visit_end_time
      not_used
      events_sequence
      uncleaned_search_terms_sequence
      search_terms_sequence
      top_level_taxons
      page_format_sequence
      not_used
      pages_sequence
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      not_used
      page_path
      q1_answer
      q2_answer
      q3_answer
      not_used_q4
      not_used_q5
      q6_answer
      q7_answer
      q8_answer
      not_used
      not_used
      not_used
      user_groups
      exact_phrases
      generic_phrases
    ]
  end

  def initialize
    @devices = Device.all.index_by { |d| d.name.downcase }
    @channels = Channel.all.index_by { |c| c.name.downcase }
    @questions = Question.all
    @phrases ||= []
    @user_groups ||= []
    @survey_phrases ||= []
    @survey_user_groups ||= []
    @page_visits ||= []
    @search_visits ||= []
    @event_visits ||= []
    @survey_visits ||= []
    @phrase_generic_phrases = []
    @verb_adjective_regex = /^([\w\s-]+),\s?([\w\s-]+)$/
  end

  def channel(search_term)
    # hard coded a "not specified" for when the channel is blank - a bit ugly, but it works
    return channels["not specified"] if search_term.blank?
    raise "\"#{search_term}\" does not exist in the channels table" if channels[search_term.downcase].nil?

    channels[search_term.downcase]
  end

  def device(search_term)
    # hard coded a "not specified" for when the device is blank - a bit ugly, but it works
    return devices["not specified"] if search_term.blank?
    raise "\"#{search_term}\" does not exist in the devices table" if devices[search_term.downcase].nil?

    devices[search_term.downcase]
  end

  def call
    started_at = Time.current
    # The import can easily generate hundreds of mb of logs when run in dev mode
    # and will slow it down so suppress logs
    ActiveRecord::Base.logger.silence do
      ActiveRecord::Base.connection.cache do
        CSV.foreach("tmp/data.csv", { headers: header_fields, header_converters: [:symbol] }) do |row|
          # I haven't figured out a way to skip the header row when passing an array
          # to headers in CSV.foreach. If we pass `headers: true`, it skips, but with an
          # array, it returns the header row as part of the result set.
          # So, manually skip the first row until we figure out something more elegant
          next if row[:ga_primary_key] == "primary_key"

          visit = insert_visit(row)
          survey = insert_survey(row, visit)
          insert_survey_answers(row, survey)
          insert_phrases(row, survey)
          insert_generic_phrases(row)
          insert_user_groups(row, survey)
          insert_page_visits(row, visit)
          insert_search_visits(row, visit)
          insert_event_visits(row, visit)
        end
      end
    end

    PageVisit.create(@page_visits)
    SurveyUserGroup.create!(@survey_user_groups)
    Mention.create(@survey_phrases)
    SearchVisit.create(@search_visits)
    EventVisit.create(@event_visits)
    PhraseGenericPhrase.create(@phrase_generic_phrases)

    # Update search indicies
    Page.import(force: true, refresh: true)
    Survey.import(force: true, refresh: true)

    puts %(Record summary:
      Adjective: #{Adjective.count}
      Event: #{Event.count}
      EventVisit: #{EventVisit.count}
      GenericPhrase: #{GenericPhrase.count}
      Mention: #{Mention.count}
      Page: #{Page.count}
      PageVisit: #{PageVisit.count}
      Phrase: #{Phrase.count}
      PhraseGenericPhrase: #{PhraseGenericPhrase.count}
      Search: #{Search.count}
      SearchVisit: #{SearchVisit.count}
      Survey: #{Survey.count}
      SurveyAnswer: #{SurveyAnswer.count}
      SurveyUserGroup: #{SurveyUserGroup.count}
      SurveyVisit: #{SurveyVisit.count}
      UserGroup: #{UserGroup.count}
      Verb: #{Verb.count}
      Visit: #{Visit.count}
      Visitor: #{Visitor.count}
    )
    puts "Import finished, took #{Time.current - started_at} seconds"
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
      name: row[:org] || "Not specified",
    )
  end

  def insert_survey(row, visit)
    organisation = upsert_organisation(row)

    survey = Survey.find_by(
      organisation_id: organisation.id,
      visitor_id: visit.visitor_id,
      ga_primary_key: row[:ga_primary_key],
      intents_client_id: row[:intents_client_id],
      started_at: row[:started_at],
      ended_at: row[:ended_at],
      full_path: row[:page_path],
      section: row[:section] || "Not specified",
    )

    if survey.nil?
      survey = Survey.new(
        organisation_id: organisation.id,
        visitor_id: visit.visitor_id,
        ga_primary_key: row[:ga_primary_key],
        intents_client_id: row[:intents_client_id],
        started_at: row[:started_at],
        ended_at: row[:ended_at],
        full_path: row[:page_path],
        section: row[:section] || "Not specified",
      )
      survey.no_index = true
      survey.save
    end

    SurveyVisit.create(
      survey: survey,
      visit: visit,
    )
  end

  def insert_survey_answers(row, survey)
    unless SurveyAnswer.find_by(survey_id: survey.id)
      survey_answers = questions.map do |question|
        answer_row_header = "q#{question.question_number}_answer".to_sym
        {
          survey_id: survey.id,
          question_id: question.id,
          answer: row[answer_row_header],
        }
      end
      SurveyAnswer.create(survey_answers)
    end
  end

  def upsert_page(page_base_path)
    page = Page.find_by(base_path: page_base_path)
    if !page
      page = Page.new(base_path: page_base_path)
      page.no_index = true
      page.save
    end
    page
  end

  def insert_page_visits(row, visit)
    unless row[:pages_sequence].nil?
      pages = split_sequence(row[:pages_sequence])

      @page_visits += pages.each_with_index.map do |page_base_path, i|
        page = upsert_page(page_base_path)

        {
          page_id: page.id,
          visit_id: visit.id,
          sequence: i + 1,
        }
      end
    end
  end

  def upsert_search(search)
    Search.find_or_create_by(
      search_string: search,
    )
  end

  def insert_search_visits(row, visit)
    unless row[:search_terms_sequence].nil?
      searches = split_sequence(row[:search_terms_sequence])

      @search_visits += searches.each_with_index.map do |search, i|
        search = upsert_search(search)

        {
          search_id: search.id,
          visit_id: visit.id,
          sequence: i + 1,
        }
      end
    end
  end

  def upsert_event(event_name_action)
    Event.find_or_create_by(
      name: event_name_action,
    )
  end

  def insert_event_visits(row, visit)
    unless row[:events_sequence].nil?
      events = split_sequence(row[:events_sequence])

      @event_visits += events.each_with_index.map do |event_name_action, i|
        event = upsert_event(event_name_action)
        {
          event_id: event.id,
          visit_id: visit.id,
          sequence: i + 1,
        }
      end
    end
  end

  def upsert_phrase(phrase_text)
    Phrase.find_or_create_by(
      phrase_text: phrase_text,
    )
  end

  def insert_phrases(row, survey)
    unless row[:exact_phrases].nil?
      cleaned_phrases = row[:exact_phrases].scan(verb_adjective_regex).map { |verb, adj| "#{verb} #{adj}" }
      question = questions_by_question_number(3) # We're only taking phrases from Question 3 at the moment
      survey_answer = SurveyAnswer.find_by(survey_id: survey.id, question_id: question.id)

      @survey_phrases += cleaned_phrases.map do |phrase_text|
        phrase = upsert_phrase(phrase_text)

        {
          phrase_id: phrase.id,
          survey_answer_id: survey_answer.id,
        }
      end
    end
  end

  def upsert_verb(verb)
    Verb.find_or_create_by(
      name: verb,
    )
  end

  def upsert_adjective(adjective)
    Adjective.find_or_create_by(
      name: adjective,
    )
  end

  def upsert_generic_phrase(verb, adjective)
    verb = upsert_verb(verb)
    adjective = upsert_adjective(adjective)

    GenericPhrase.find_or_create_by(
      verb: verb,
      adjective: adjective,
    )
  end

  def insert_generic_phrases(row)
    unless row[:exact_phrases].nil? || row[:generic_phrases].nil?
      exact_phrase_matches = row[:exact_phrases].scan(verb_adjective_regex)
      generic_phrase_matches = row[:generic_phrases].scan(verb_adjective_regex)

      @phrase_generic_phrases += exact_phrase_matches.zip(generic_phrase_matches).map do |exact, generic|
        exact_phrase_text = "#{phrase_verb(exact)} #{phrase_adj(exact)}"

        phrase = upsert_phrase(exact_phrase_text)
        generic_phrase = upsert_generic_phrase(phrase_verb(generic), phrase_adj(generic))

        {
          phrase_id: phrase.id,
          generic_phrase_id: generic_phrase.id,
        }
      end
    end
  end

  def phrase_verb(phrase_arr)
    phrase_arr[0]
  end

  def phrase_adj(phrase_arr)
    phrase_arr[1]
  end

  def upsert_user_group(user_group)
    UserGroup.find_or_create_by(
      group: user_group,
    )
  end

  def insert_user_groups(row, survey)
    unless row[:user_groups].nil?
      user_groups = split_sequence(row[:user_groups])

      @survey_user_groups += user_groups.map do |user_group_text|
        {
          survey_id: survey.id,
          user_group_id: upsert_user_group(user_group_text).id,
        }
      end
    end
  end

  def split_sequence(sequence)
    # Data can be joined by '>>', '<<' or older by ', '
    if sequence.include?(">>")
      sequence.split(">>")
    elsif sequence.include?("<<")
      sequence.split("<<")
    else
      sequence.split(", ")
    end
  end

  def questions_by_question_number(question_number)
    @questions_by_question_number ||= questions.index_by(&:question_number)

    @questions_by_question_number[question_number]
  end

private

  attr_reader :verb_adjective_regex
end
