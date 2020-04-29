class DropSurveyPhrases < ActiveRecord::Migration[6.0]
  def change
    drop_table :survey_phrases
  end
end
