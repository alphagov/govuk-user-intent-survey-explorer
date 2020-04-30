module SummaryHelper
  include Kaminari::Helpers::HelperMethods

  def sort_directions
    {
      asc: "ascending",
      desc: "descending",
    }
  end

  def get_table_headers(presenter)
    column_map = {
      "base_path" => {
        text: "Page",
        href: "/summary?sort_key=base_path&sort_direction=asc&q=#{params[:q]}",
      },
      "unique_visits" => {
        text: "Unique page views",
        format: "numeric",
        href: "/summary?sort_key=unique_visits&sort_direction=asc&q=#{params[:q]}",
      },
      "total_pageviews" => {
        text: "Page views",
        format: "numeric",
        href: "/summary?sort_key=total_pageviews&sort_direction=asc&q=#{params[:q]}",
      },
    }

    if presenter.sort_key.present?
      dir = presenter.sort_direction == :asc ? :desc : :asc
      column_map[presenter.sort_key].merge!(
        {
          sort_direction: sort_directions[presenter.sort_direction],
          href: "/summary?sort_key=#{presenter.sort_key}&sort_direction=#{dir}&page=#{presenter.page}&q=#{params[:q]}",
        },
      )
    end

    column_map.values
  end

  def map_content_pages_to_table(presenter)
    presenter.items.map do |page|
      link = link_to page.base_path, "/pages/#{page.id}"

      [
        {
          text: link,
        },
        {
          text: page.unique_visits,
          format: "numeric",
        },
        {
          text: page.total_pageviews,
          format: "numeric",
        },
      ]
    end
  end
end
