module PagesVisitedHelper
  def pages_visited_navigation_links
    links = {}

    if @presenter.pagination.page > 1
      links = links.merge(
        previous_page: {
          url: path_to_previous_page(@presenter.unique_visitors_by_page),
          title: "Previous page",
          label: "#{@presenter.pagination.page - 1} of #{@presenter.pagination.total_pages}"
        }
      )
    end

    if @presenter.pagination.page < @presenter.pagination.total_pages
      links = links.merge(
        next_page: {
          url: path_to_next_page(@presenter.unique_visitors_by_page),
          title: "Next page",
          label: "#{@presenter.pagination.page + 1} of #{@presenter.pagination.total_pages}"
        }
      )
    end

    links
  end

  def page_visited_table_headers
    column_map = {
      "base_path" => {
        text: "Page title",
        href: "#{pages_visited_path(@phrase)}?sort_key=base_path&sort_direction=asc"
      },
      "unique_visitors" => {
        text: "Number of unique visitors",
        format: "numeric",
        href: "#{pages_visited_path(@phrase)}?sort_key=unique_visitors&sort_direction=asc",
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
      link = link_to row[:base_path], "https://www.gov.uk#{row[:base_path]}"

      [
        { text: link },
        { text: row[:unique_visitors], format: 'numeric' }
      ]
    end
  end
end
