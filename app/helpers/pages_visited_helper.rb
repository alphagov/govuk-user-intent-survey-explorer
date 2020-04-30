module PagesVisitedHelper
  def page_visited_table_headers(presenter)
    column_map = {
      "base_path" => {
        text: "Page title",
        href: "#{pages_visited_path(presenter.phrase)}?sort_key=base_path&sort_direction=asc",
      },
      "unique_visitors" => {
        text: "Number of unique visitors",
        format: "numeric",
        href: "#{pages_visited_path(presenter.phrase)}?sort_key=unique_visitors&sort_direction=asc",
      },
    }

    if presenter.sort_key.present?
      dir = presenter.sort_direction == :asc ? :desc : :asc
      column_map[presenter.sort_key].merge!(
        {
          sort_direction: sort_directions[presenter.sort_direction],
          href: "#{pages_visited_path(presenter.phrase)}?sort_key=#{presenter.sort_key}&sort_direction=#{dir}&page=#{presenter.page}",
        },
      )
    end

    column_map.values
  end

  def map_pages_visited_data_to_table(data)
    data.map do |row|
      link = link_to row[:base_path], "https://www.gov.uk#{row[:base_path]}"

      [
        { text: link },
        { text: row[:unique_visitors], format: "numeric" },
      ]
    end
  end
end
