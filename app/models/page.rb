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
end
