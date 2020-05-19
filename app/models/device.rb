class Device < ApplicationRecord
  has_many :visits, dependent: :destroy

  def self.breakdown_by_date_range_for_phrase(phrase, start_date, end_date)
    date_range = start_date..end_date

    Device.joins(visits: [{ visitor: [{ surveys: [{ survey_answers: [{ mentions: :phrase }] }] }] }])
      .where("phrases.id" => phrase.id, "surveys.started_at" => date_range)
      .group("devices.id")
      .order("devices.id")
      .pluck("devices.name", "count(visits.device_id)")
  end

  def self.for_page(page, start_date, end_date)
    date_range = start_date..end_date

    Device.joins(visits: [:page_visits, visitor: :surveys])
      .where("page_visits.page_id" => page.id)
      .where("surveys.started_at" => date_range)
      .group("devices.id")
      .order("devices.id")
      .pluck("devices.name", "count(visits.device_id)")
      .map { |name, visits_total| { name: name, visits_total: visits_total } }
  end
end
