module ::PageTitleable
  extend ActiveSupport::Concern

  def page_title(base_path, items)
    # Search API doesn't index all documents, so it won't always return
    # a result for every base path we pass it.
    return search_api_page_titles(items)[base_path] if search_api_page_titles(items).has_key?(base_path)

    # If the search results don't include the base path we want
    # we hit the Content Store API, which will
    begin
      content_store_page_title(base_path)
    rescue GdsApi::ContentStore::ItemNotFound, GdsApi::InvalidUrl
      # Sometimes we can have a url that the content store does not recognise
      # because we're relying on urls from a non canonical source
      # (for example if it has a lot of parameters in it or it's a sub item of another)
      # We need to find a long term solution to this
      ""
    end
  end

  def search_api_page_titles(items)
    return cached_search_api_page_titles[items] if cached_search_api_page_titles.has_key?(items)

    search_api_results = Services.search_api.search(
      count: items.count,
      filter_link: items.map { |item| item[:base_path] },
      fields: %i[link title],
    )
    .to_hash["results"]
    .each_with_object({}) { |result, hash| hash[result["link"]] = result["title"] }

    cached_search_api_page_titles[items] = search_api_results
  end

  def content_store_page_title(base_path)
    return cached_content_store_page_title[base_path] if cached_content_store_page_title.has_key?(base_path)

    cached_content_store_page_title[base_path] = Services.content_store.content_item(base_path)["title"]
  end

private

  def cached_content_store_page_title
    @cached_content_store_page_title ||= {}
  end

  def cached_search_api_page_titles
    @cached_search_api_page_titles ||= {}
  end
end
