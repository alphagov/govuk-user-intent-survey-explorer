require 'active_support'
require 'active_support/core_ext/integer/inflections'

module NumberOfMentionsHelper
  def map_mentions_data_to_table(data)
    data.map do |row|
      [
        { text: row.date.strftime("#{row.date.day.ordinalize} %b %Y") },
        { text: row.total_mentions, format: 'numeric' }
      ]
    end
  end
end
