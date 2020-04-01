require 'elasticsearch/model'

class Survey < ApplicationRecord
  belongs_to :organisation
  belongs_to :visitor
  has_many :visits
  has_many :questions, through: :visits
  has_many :survey_answers, -> { order(:question_id) }

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(options = {})
    {
      responses: survey_answers.preload(:question).to_a.
          keep_if { |answer| answer.question.free_text_response }.
          map(&:answer).join(" ")
    }.as_json
  end
end
