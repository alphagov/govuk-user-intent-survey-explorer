class Device < ApplicationRecord
  has_many :visits

  def self.breakdown_by_date_range(start_date, end_date)
    device_totals = Device
      .find_by_sql("select devices.id, devices.name, count(v.device_id) as total from survey_phrases m join phrases on phrases.id = m.phrase_id join survey_answers sa on sa.id = m.survey_answer_id join surveys s on s.id = sa.survey_id join visits v on v.visitor_id = s.visitor_id join devices on devices.id = v.device_id group by (devices.id) order by devices.id;")
      .pluck(:name, :total)

    device_totals
  end
end
