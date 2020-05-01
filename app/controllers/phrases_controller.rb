class PhrasesController < ApplicationController
  def show
    @phrase = Phrase.find(params[:id])
    @devices = devices
    @pages_visited = pages_visited
    @mentions = mentions
    @survey_answers_containing_phrase = SurveyAnswer.find_by_sql(["select * from survey_answers sa join questions q on q.id = sa.question_id join mentions sp on sp.survey_answer_id = sa.id join phrases p on p.id = sp.phrase_id where p.id = ? and q.question_number = 3 and sa.answer not like '-' limit 3", @phrase.id.to_s])
  end

  def usage
    @phrase = Phrase.find(params[:id])
    @presenter = PhraseUsagePresenter.new(survey_answers_containing_phrase, search_params)
  end

private

  def devices
    device_totals = Device.breakdown_by_date_range_for_phrase(@phrase, Date.new(2020, 4, 1), Date.new(2020, 4, 7))

    all_device_hits_total = device_totals.sum { |_, total| total }

    device_totals.map do |device_name, device_total|
      { device_type: device_name, percentage_use: (device_total.to_f / all_device_hits_total) }
    end
  end

  def pages_visited
    Page.total_visitors_for_phrase(@phrase, Date.new(2020, 4, 1), Date.new(2020, 4, 7))
  end

  def mentions
    Mention
      .mentions_by_date_range_for_phrase(@phrase, Date.new(2020, 4, 1), Date.new(2020, 4, 7))
      .sort_by { |date, _| date }
      .to_h
  end

  def survey_answers_containing_phrase
    SurveyAnswer.find_by_sql(["select * from survey_answers sa join questions q on q.id = sa.question_id join mentions sp on sp.survey_answer_id = sa.id join phrases p on p.id = sp.phrase_id where p.id = ? and q.question_number = 3 and sa.answer not like '-'", params[:id].to_s])
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
