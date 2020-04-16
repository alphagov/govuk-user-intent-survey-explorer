class PhraseController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @pages_visited = Page.limit(10)
    @devices_used = [
      { device_type: 'Desktop', percentage_use: 0.35 },
      { device_type: 'Mobile', percentage_use: 0.6 },
      { device_type: 'Tablet', percentage_use: 0.04 }
    ]
    @mentions = [
      'My passport has been mislaid by the Pakistan High Commission. I sent it there to get a visa to visit Pakistan. Now they are asking for my passport number How can I find out my passport number, as I have asthma, if I do not have the passport in my possession?',
      'My passport has been mislaid by the Pakistan High Commission. I sent it there to get a visa to visit Pakistan. Now they are asking for my passport number How can I find out my passport number, as I have asthma, if I do not have the passport in my possession?',
      'My passport has been mislaid by the Pakistan High Commission. I sent it there to get a visa to visit Pakistan. Now they are asking for my passport number How can I find out my passport number, as I have asthma, if I do not have the passport in my possession?'
    ]
    @total_mentions = 127530
    @mentions_by_day = {
      '03/04' => '27632',
      '04/04' => '25055',
      '05/04' => '25602',
      '06/04' => '26051',
      '07/04' => '25437',
      '08/04' => '13006',
      '09/04' => '9991'
    }
  end
end
