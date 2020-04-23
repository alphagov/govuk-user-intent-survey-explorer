class NumberOfMentionsController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @mentions = mentions
  end

private

  def mentions
    SurveyPhrase.mentions_by_date_range_for_phrase(@phrase, Date.new(2020, 4, 1), Date.new(2020, 4, 7))
      .sort_by{ |date, _| date }
  end
end
