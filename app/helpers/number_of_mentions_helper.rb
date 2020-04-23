require 'active_support'
require 'active_support/core_ext/integer/inflections'

module NumberOfMentionsHelper
  def map_mentions_data_to_table(data)
    data.map do |date, total_mentions|
      [
        { text: date.strftime("#{date.day.ordinalize} %b %Y") },
        { text: total_mentions, format: 'numeric' }
      ]
    end
  end
end
