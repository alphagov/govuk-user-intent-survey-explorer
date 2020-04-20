module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%d-%m-%y at %H:%M")
  end

  def map_mentions_data_to_chart(mentions_data)
    mentions_data.each_with_object({}) do |m, hash|
      date = DateTime.parse(m.date).strftime('%-d %b')
      hash[date] = m.total_mentions
    end
  end
end
