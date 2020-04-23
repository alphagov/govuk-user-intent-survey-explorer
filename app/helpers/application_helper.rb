module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%d-%m-%y at %H:%M")
  end

  def map_mentions_data_to_chart(mentions_data)
    mentions_data.each_with_object({}){|(date, total_mentions), hash| hash[date.strftime('%-d %b')] = total_mentions }
  end

  def total_mentions(mentions_data)
    mentions_data.sum {|_, daily_mentions| daily_mentions }
  end
end
