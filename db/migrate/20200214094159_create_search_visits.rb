class CreateSearchVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :search_visits do |t|
      t.references :search, null: false, foreign_key: true
      t.references :visit, null: false, foreign_key: true
      t.integer :sequence
    end
  end
end
