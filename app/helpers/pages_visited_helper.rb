module PagesVisitedHelper
  def map_pages_visited_data_to_table(data)
    data.map do |base_path, unique_visitors|
      link = link_to base_path, "https://www.gov.uk#{base_path}"

      [
        { text: link },
        { text: unique_visitors, format: "numeric" },
      ]
    end
  end
end
