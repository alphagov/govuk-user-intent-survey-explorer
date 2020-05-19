class PagePresenter
  attr_reader :survey_counts
  delegate :base_path, :url_friendly_base_path, to: :page
  include ActionView::Helpers::TagHelper
  include ::PageTitleable

  def initialize(page, survey_counts, top_generic_phrases, top_user_groups, top_visits_last_page, top_visits_next_page, survey_answers, devices)
    @page = page
    @survey_counts = survey_counts
    @top_generic_phrases = top_generic_phrases
    @top_user_groups = top_user_groups
    @top_visits_last_page = top_visits_last_page
    @top_visits_next_page = top_visits_next_page
    @survey_answers = survey_answers
    @devices = devices
  end

  def title
    content_item["title"]
  end

  def public_updated_at
    DateTime.parse(content_item["public_updated_at"]).strftime("%-l:%M %P on %-d %B %Y")
  end

  def organisation
    organisations = content_item["links"].fetch("organisations", [])
    if organisations.any?
      organisations.first["title"]
    end
  end

  def document_type
    content_item["document_type"].gsub("_", " ").capitalize
  end

  def total_survey_counts
    survey_counts.values.reduce(&:+)
  end

  def top_generic_phrases_rows
    top_generic_phrases.each_with_object([]) do |phrase, result|
      result << [
        {
          text: phrase[:phrase_text],
        },
        {
          text: phrase[:total],
          format: "numeric",
        },
      ]
    end
  end

  def top_user_groups_rows
    top_user_groups.each_with_object([]) do |phrase, result|
      result << [
        {
          text: phrase[:group_name],
        },
        {
          text: phrase[:total],
          format: "numeric",
        },
      ]
    end
  end

  def top_visits_last_page_rows
    top_pages_for_visits_rows(top_visits_last_page)
  end

  def top_visits_next_page_rows
    top_pages_for_visits_rows(top_visits_next_page)
  end

  def survey_answer_text
    survey_answers.map do |survey_answer|
      content_tag(:p, survey_answer[:answer]) +
        content_tag(:p, survey_answer[:device_name], class: "inline") +
        content_tag(:p, survey_answer[:survey_started_at].strftime("%-d %B %Y"), class: "inline govuk-!-margin-left-4")
    end
  end

  def devices_rows
    devices.map do |device|
      [
        {
          text: device[:name],
        },
        {
          text: device_percentage(device[:visits_total]),
          format: "numeric",
        },
      ]
    end
  end

private

  attr_reader :page, :top_user_groups, :top_generic_phrases, :top_visits_last_page, :top_visits_next_page, :survey_answers, :devices

  def top_pages_for_visits_rows(top_pages)
    top_pages.each_with_object([]) do |page, result|
      result << [
        {
          text: page_title(page[:base_path], top_pages),
        },
        {
          text: page[:unique_visitor_count],
          format: "numeric",
        },
      ]
    end
  end

  def device_percentage(total_for_device)
    return "0%" if total_for_device.zero?

    total = devices.map { |device| device[:visits_total] }.reduce(&:+).to_f
    percentage = ((total_for_device.to_f / total) * 100).round(0)
    "#{percentage}%"
  end

  def content_item
    @content_item ||= begin
      Services.content_store.content_item(page.base_path)
    end
  end
end
