class SurveyVisit < ApplicationRecord
  belongs_to :survey
  belongs_to :visit
end
