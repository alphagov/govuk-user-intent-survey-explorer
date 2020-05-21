class PhrasesController < ApplicationController
  include Searchable

  def show
    @phrase = Phrase.find(params[:id])
    @devices = devices
    @pages_visited = pages_visited
    @mentions = mentions
    @survey_answers_containing_phrase = survey_answers_containing_phrase.take(3)
  end

  def usage
    @phrase = Phrase.find(params[:id])
    @presenter = PhraseUsagePresenter.new(survey_answers_containing_phrase, search_params)
  end

private

  def devices
    device_totals = Device.breakdown_by_date_range_for_phrase(@phrase, from_date_as_datetime, to_date_as_datetime)

    all_device_hits_total = device_totals.sum { |_, total| total }

    device_totals.map do |device_name, device_total|
      { device_type: device_name, percentage_use: (device_total.to_f / all_device_hits_total) }
    end
  end

  def pages_visited
    Page.total_visitors_for_phrase(@phrase, from_date_as_datetime, to_date_as_datetime)
  end

  def mentions
    Mention
      .mentions_by_date_range_for_phrase(@phrase, from_date_as_datetime, to_date_as_datetime)
      .sort_by { |date, _| date }
      .to_h
  end

  def survey_answers_containing_phrase
    SurveyAnswer.for_phrase(@phrase, from_date_as_datetime, to_date_as_datetime)
  end

  def search_params
    @search_params ||= begin
      { page: 1 }.merge(
        params.permit(
          :page,
        ).to_h.symbolize_keys,
      )
    end
  end
end
