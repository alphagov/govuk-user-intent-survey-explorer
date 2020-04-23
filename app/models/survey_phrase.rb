class SurveyPhrase < ApplicationRecord
  belongs_to :phrase
  belongs_to :survey_answer

  def self.mentions_by_date_range_for_phrase(phrase, start_date, end_date)
    date_range = start_date..end_date

    mentions = SurveyPhrase.joins(:phrase, survey_answer: :survey)
     .where(phrase: phrase, 'surveys.started_at' => date_range)
     .group('date(surveys.started_at)')
     .order('date(surveys.started_at) asc')
     .limit(10)
     .pluck('date(surveys.started_at)', 'count(survey_phrases.id)')

    present_dates = mentions.map { |date, _| date }

    date_range.each do |date|
      unless present_dates.include?(date)
        mentions << [date, 0]
      end
    end

    mentions
  end
end
