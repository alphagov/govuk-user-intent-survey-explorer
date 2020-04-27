class CreateSurveyUserGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_user_groups do |t|
      t.references :survey, null: false, foreign_key: true
      t.references :user_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
