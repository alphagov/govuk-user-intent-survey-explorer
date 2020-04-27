class SurveyUserGroup < ApplicationRecord
  belongs_to :survey
  belongs_to :user_group
end
