class CreateSurveyVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_visits do |t|
      t.references :survey, null: false, foreign_key: true
      t.references :visit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
