# require 'elasticsearch/model'

class Page < ApplicationRecord
  has_many :page_visits
  has_many :visits, through: :page_visits

  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  # mapping do
  #   indexes :base_path, type: 'text', analyzer: 'english' do
  #   end
  # end
end
