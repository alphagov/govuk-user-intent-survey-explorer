module NumberOfMentionsHelper
  def map_mentions_data_to_table(data)
    data.map do |row|
      [
        { text: row[:date] },
        { text: row[:mentions], format: 'numeric' }
      ]
    end
  end

  def map_mentions_data_to_chart(data)
    data.each_with_object({}){|d, hash| hash[d[:date]] = d[:mentions] }
  end
end
