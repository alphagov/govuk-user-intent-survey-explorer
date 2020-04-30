module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%d-%m-%y at %H:%M")
  end

  def map_mentions_data_to_chart(mentions_data)
    mentions_data.each_with_object({}) { |(date, total_mentions), hash| hash[date.strftime("%-d %b")] = total_mentions }
  end

  def total_mentions(mentions_data)
    mentions_data.sum { |_, daily_mentions| daily_mentions }
  end

  def navigation_links(presenter)
    links = {}

    if presenter.page > 1
      links = links.merge(
        previous_page: {
          url: path_to_previous_page(presenter.items),
          title: "Previous page",
          label: "#{presenter.page - 1} of #{presenter.total_pages}",
        },
      )
    end

    if presenter.page < presenter.total_pages
      links = links.merge(
        next_page: {
          url: path_to_next_page(presenter.items),
          title: "Next page",
          label: "#{presenter.page + 1} of #{presenter.total_pages}",
        },
      )
    end

    links
  end
end
