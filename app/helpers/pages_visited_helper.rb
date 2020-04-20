module PagesVisitedHelper
  def map_pages_visited_data_to_table(data)
    data.map do |row|
      [
        { text: row[:base_path] },
        { text: row[:unique_visitors], format: 'numeric' }
      ]
    end
  end
end
