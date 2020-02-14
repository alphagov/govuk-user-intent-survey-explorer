class CreateSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.references :organisation, null: false, foreign_key: true
      t.references :visitor, null: false, foreign_key: true
      t.string :ga_primary_key
      t.string :intents_client_id
      t.datetime :started_at
      t.datetime :ended_at
      t.string :full_path
      t.string :section

      t.timestamps
    end
  end
end
