module PagesVisitedHelper
  def page_visited_table_headers
    column_map = {
      "base_path" => {
        text: "Page title",
        href: "#{pages_visited_path(@phrase)}?sort_key=base_path&sort_direction=asc"
      },
      "unique_visitors" => {
        text: "Number of unique visitors",
        format: "numeric",
        href: "#{pages_visited_path(@phrase)}?sort_key=unique_visitors&sort_direction=asc"
      }
    }

    unless @presenter.sorting.sort_key.blank?
      dir = @presenter.sorting.sort_direction == :asc ? :desc : :asc
      column_map[@presenter.sorting.sort_key].merge!(
        {
          sort_direction: sort_directions[@presenter.sorting.sort_direction],
          href: "#{pages_visited_path(@phrase)}?sort_key=#{@presenter.sorting.sort_key}&sort_direction=#{dir}&page=#{@presenter.pagination.page}"
        }
      )
    end

    column_map.values
  end

  def map_pages_visited_data_to_table(data)
    data.map do |row|
      [
        { text: row[:base_path] },
        { text: row[:unique_visitors], format: 'numeric' }
      ]
    end
  end
end
