class NumberOfMentionsController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @total_mentions = 127530
    @mentions_by_day = [
      { date: '03/04', mentions: '27632' },
      { date: '04/04', mentions: '25055' },
      { date: '05/04', mentions: '25602' },
      { date: '06/04', mentions: '26051' },
      { date: '07/04', mentions: '25437' },
      { date: '08/04', mentions: '13006' },
      { date: '09/04', mentions: '9991' }
    ]
  end
end
