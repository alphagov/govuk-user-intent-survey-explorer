class CreateMentions < ActiveRecord::Migration[6.0]
  def change
    create_table :mentions do |t|
      t.references :phrase, null: false, foreign_key: true
      t.references :survey_answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
