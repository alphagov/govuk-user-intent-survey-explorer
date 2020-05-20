require "elasticsearch/model"

class Page < ApplicationRecord
  attr_accessor :no_index

  has_many :page_visits, dependent: :destroy
  has_many :visits, through: :page_visits

  include Elasticsearch::Model
  after_commit lambda { __elasticsearch__.index_document  },  on: :create, unless: -> { no_index }
  after_commit lambda { __elasticsearch__.update_document },  on: :update
  after_commit lambda { __elasticsearch__.delete_document },  on: :destroy

  mapping do
    indexes :base_path, type: "text", analyzer: "english" do
    end
  end

  def url_friendly_base_path
    base_path.sub(/^\/(?!$)/, "")
  end

  def self.top_pages(start_date, end_date)
    date_range = start_date..end_date

    Page.joins(page_visits: [{ visit: [{ survey_visit: :survey }] }])
      .where("surveys.started_at" => date_range)
      .group("pages.id")
      .order("total_pageviews desc, pages.base_path asc")
      .pluck("pages.base_path", "count(page_visits.visit_id) as total_pageviews")
  end

  def self.total_visitors_for_phrase(phrase, start_date, end_date, sort_key: "total_visitors", sort_dir: "desc")
    date_range = start_date..end_date

    Page.joins(page_visits: [{ visit: [{ survey_visit: [{ survey: [{ survey_answers: [{ mentions: :phrase }] }] }] }] }])
      .where("phrases.id" => phrase.id, "surveys.started_at" => date_range)
      .group("pages.id")
      .order("#{sort_key} #{sort_dir}")
      .pluck("pages.base_path", "count(page_visits.visit_id) as total_visitors")
  end

  def self.unique_visitors_for_phrase(phrase, start_date, end_date, sort_key: "unique_visitors", sort_dir: "desc")
    date_range = start_date..end_date

    Page.joins(page_visits: [{ visit: [{ survey_visit: [{ survey: [{ survey_answers: [{ mentions: :phrase }] }] }] }] }])
      .where("phrases.id" => phrase.id, "surveys.started_at" => date_range)
      .group("pages.id")
      .order("#{sort_key} #{sort_dir}")
      .pluck("pages.base_path", "count(distinct(page_visits.visit_id)) as unique_visitors")
  end

  def self.search_by_base_path(query_base_path, start_date, end_date, options = {})
    options = {
      sort_key: "feedback_comments",
      sort_dir: "desc",
      verb: "%",
      adjective: "%",
    }.merge!(options)

    date_range = start_date..end_date

    Page.joins(page_visits: [{ visit: [{ survey_visit: [{ survey: [{ survey_answers: [{ mentions: [{ phrase: [{ phrase_generic_phrases: [{ generic_phrase: %i[verb adjective] }] }] }] }] }] }] }] }])
      .where("surveys.started_at" => date_range)
      .where("pages.base_path like ?", "%#{query_base_path}%")
      .where("verbs.name like ?", options[:verb])
      .where("adjectives.name like ?", options[:adjective])
      .group("pages.id")
      .order("#{options[:sort_key]} #{options[:sort_dir]}")
      .pluck("pages.base_path as page_base_path", "count(distinct(surveys.id)) as feedback_comments", "pages.id")
      .map { |base_path, feedback_comments, page_id| { base_path: base_path, survey_count: feedback_comments, page_id: page_id } }
  end
end
