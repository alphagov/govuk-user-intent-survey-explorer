require "elasticsearch/model"

class Page < ApplicationRecord
  has_many :page_visits, dependent: :destroy
  has_many :visits, through: :page_visits

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mapping do
    indexes :base_path, type: "text", analyzer: "english" do
    end
  end

  def self.unique_visitors_for_phrase(phrase, start_date, end_date, sort_key: "unique_visitors", sort_dir: "desc")
    date_range = start_date..end_date

    Page.joins(page_visits: [{ visit: [{ survey_visit: [{ survey: [{ survey_answers: [{ mentions: :phrase }] }] }] }] }])
      .where("phrases.id" => phrase.id, "surveys.started_at" => date_range)
      .group("pages.id")
      .order("#{sort_key} #{sort_dir}")
      .pluck("pages.base_path", "count(distinct(page_visits.visit_id)) as unique_visitors")
  end

  def self.total_visitors_for_phrase(phrase, start_date, end_date, sort_key: "total_visitors", sort_dir: "desc")
    date_range = start_date..end_date

    Page.joins(page_visits: [{ visit: [{ survey_visit: [{ survey: [{ survey_answers: [{ mentions: :phrase }] }] }] }] }])
      .where("phrases.id" => phrase.id, "surveys.started_at" => date_range)
      .group("pages.id")
      .order("#{sort_key} #{sort_dir}")
      .pluck("pages.base_path", "count(page_visits.visit_id) as total_visitors")
  end
end
