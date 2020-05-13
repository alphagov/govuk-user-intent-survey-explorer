require "elasticsearch/model"

class Survey < ApplicationRecord
  attr_accessor :no_index

  belongs_to :organisation
  belongs_to :visitor
  has_many :visits, dependent: :destroy
  has_many :questions, through: :visits
  has_many(:survey_answers, -> { order(:question_id) }, inverse_of: :survey)
  has_many :survey_user_groups, dependent: :destroy
  has_one :survey_visit, dependent: :destroy

  include Elasticsearch::Model
  after_commit lambda { __elasticsearch__.index_document  },  on: :create, unless: -> { no_index }
  after_commit lambda { __elasticsearch__.update_document },  on: :update
  after_commit lambda { __elasticsearch__.delete_document },  on: :destroy

  mapping do
    indexes :responses, type: "text", analyzer: "english"
    indexes :started_at, type: "date"
  end

  def as_indexed_json(_options = {})
    {
      responses: survey_answers.preload(:question).to_a
        .keep_if { |answer| answer.question.free_text_response }
        .map(&:answer).join(" "),
      started_at: started_at.strftime("%F"),
    }.as_json
  end
end
