module GenericPhraseConcern
  extend ActiveSupport::Concern

  class_methods do
    def co_occurring_generic_phrases(generic_phrases_for_survey_answers)
      generic_phrase_combinations = []

      generic_phrases_for_survey_answers.group_by(&:first).each do |_, r|
        # Anything less than two generic phrases will automatically be removed here
        generic_phrase_combinations += r.map(&:last).combination(2).to_a
      end

      generic_phrase_combinations
    end
  end
end
