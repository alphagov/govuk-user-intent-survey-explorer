class MentionsController < ApplicationController
  include Searchable

  def show
    @phrase = Phrase.find(params[:id])
    @mentions = mentions
  end

private

  def mentions
    Mention.mentions_by_date_range_for_phrase(@phrase, from_date_as_datetime, to_date_as_datetime)
      .sort_by { |date, _| date }
  end
end
