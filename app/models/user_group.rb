class UserGroup < ApplicationRecord
  has_many :survey_user_groups, dependent: :destroy
  has_many :surveys, through: :survey_user_groups

  def self.top_user_groups_by_date(start_date, end_date)
    date_range = start_date..end_date

    UserGroup
      .joins(survey_user_groups: :survey)
      .where("surveys.started_at" => date_range)
      .group("user_groups.group")
      .order("count(survey_user_groups.user_group_id) desc")
      .limit(10)
      .pluck("user_groups.group", "count(survey_user_groups.user_group_id)")
      .map { |user_group, total| { group_name: user_group, total: total } }
  end
end
