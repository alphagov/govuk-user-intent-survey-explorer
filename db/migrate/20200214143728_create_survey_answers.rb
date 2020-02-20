class CreateSurveyAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_answers do |t|
      t.references :survey, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.string :answer

      t.timestamps
    end
  end
end
