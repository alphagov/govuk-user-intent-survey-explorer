class CreatePhraseGenericPhrases < ActiveRecord::Migration[6.0]
  def change
    create_table :phrase_generic_phrases do |t|
      t.references :phrase, null: false, foreign_key: true
      t.references :generic_phrase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
