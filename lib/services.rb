require "gds_api/search"

module Services
  def self.search_api
    @search_api ||= GdsApi::Search.new("https://www.gov.uk/api")
  end

  def self.content_store
    @content_store ||= GdsApi::ContentStore.new("https://www.gov.uk/api")
  end
end
