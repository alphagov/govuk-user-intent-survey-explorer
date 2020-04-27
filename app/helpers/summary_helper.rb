module SummaryHelper
  include Kaminari::Helpers::HelperMethods

  def sort_directions
    {
      asc: "ascending",
      desc: "descending"
    }
  end

  def get_table_headers
    column_map = {
      "base_path" => {
        text: "Page",
        href: "/summary?sort_key=base_path&sort_direction=asc&q=#{params[:q]}"
      },
      "unique_visits" => {
        text: "Unique page views",
        format: "numeric",
        href: "/summary?sort_key=unique_visits&sort_direction=asc&q=#{params[:q]}"
      },
      "total_pageviews" => {
        text: "Page views",
        format: "numeric",
        href: "/summary?sort_key=total_pageviews&sort_direction=asc&q=#{params[:q]}"
      }
    }

    unless @presenter.sorting.sort_key.blank?
      dir = @presenter.sorting.sort_direction == :asc ? :desc : :asc
      column_map[@presenter.sorting.sort_key].merge!(
        {
          sort_direction: sort_directions[@presenter.sorting.sort_direction],
          href: "/summary?sort_key=#{@presenter.sorting.sort_key}&sort_direction=#{dir}&page=#{@presenter.pagination.page}&q=#{params[:q]}"
        }
      )
    end

    column_map.values
  end


  def map_content_pages_to_table
    @presenter.items.map do |page|
      link = link_to page.base_path, "/pages/#{page.id}"

      [
        {
          text: link
        },
        {
          text: page.unique_visits,
          format: 'numeric'
        },
        {
          text: page.total_pageviews,
          format: 'numeric'
        }
      ]
    end
  end
end
