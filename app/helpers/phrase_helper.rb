module PhraseHelper
  def map_device_data(device_data)
    device_data.map do |row|
      [
        { text: row[:device_type] },
        { text: number_to_percentage(row[:percentage_use] * 100, precision: 0), format: 'numeric' }
      ]
    end
  end

  def map_mentions_data_to_chart(mentions_data)
    mentions_data.each_with_object({}) do |m, hash|
      date = DateTime.parse(m.date).strftime('%-d %b')
      hash[date] = m.total_mentions
    end
  end
end
