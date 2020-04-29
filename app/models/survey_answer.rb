class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  has_many :mentions, dependent: :destroy
  has_many :phrases, through: :mentions
end
