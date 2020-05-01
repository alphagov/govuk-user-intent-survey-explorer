config = {
  host: ENV["ELASTIC_SEARCH_URL"] || "http://localhost:9200/",
}

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
