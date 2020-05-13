class CreateGenericPhrases < ActiveRecord::Migration[6.0]
  def change
    create_table :generic_phrases do |t|
      t.references :verb, null: false, foreign_key: true
      t.references :adjective, null: false, foreign_key: true

      t.timestamps
    end
  end
end
