class PagePresenter
  attr_reader :survey_counts
  delegate :base_path, :url_friendly_base_path, to: :page

  def initialize(page, survey_counts, top_generic_phrases, top_user_groups)
    @page = page
    @survey_counts = survey_counts
    @top_generic_phrases = top_generic_phrases
    @top_user_groups = top_user_groups
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

private

  attr_reader :page, :top_user_groups, :top_generic_phrases

  def content_item
    @content_item ||= begin
      Services.content_store.content_item(page.base_path)
    end
  end
end
