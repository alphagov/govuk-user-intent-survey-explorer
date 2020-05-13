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

  def human_readable_date_range(from, to)
    # https://www.gov.uk/guidance/style-guide/a-to-z-of-gov-uk-style#dates
    format = "%-d %B %Y"
    if from && to
      "Showing data from #{from.strftime(format)} to #{to.strftime(format)}"
    elsif from && !to
      "Showing data from #{from.strftime(format)}"
    elsif !from && to
      "Showing data to #{to.strftime(format)}"
    else
      "Showing all data"
    end
  end

  def human_readable_date_duration(from, to)
    num_days = nil
    if from && to
      num_days = (to - from).to_i
    elsif from
      num_days = (DateTime.now - from).to_i
    elsif to
      num_days = (DateTime.now - to).to_i
    end
    if num_days
      "Showing data for #{num_days} #{'day'.pluralize(num_days)}"
    end
  end
end
