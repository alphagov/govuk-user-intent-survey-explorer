require 'time'
require 'active_support'
require 'active_support/core_ext/integer/inflections'

module NumberOfMentionsHelper
  def map_mentions_data_to_table(data)
    data.map do |row|
      date = Time.parse(row.date)

      [
        { text: date.strftime("#{date.day.ordinalize} %b %Y") },
        { text: row.total_mentions, format: 'numeric' }
      ]
    end
  end

  def map_mentions_data_to_chart(data)
    data.each_with_object({}) do |m, hash|
      date = DateTime.parse(m.date).strftime('%-d %b')
      hash[date] = m.total_mentions
    end
  end
end
