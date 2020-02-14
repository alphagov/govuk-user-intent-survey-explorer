class CreatePageVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :page_visits do |t|
      t.references :page, null: false, foreign_key: true
      t.references :visit, null: false, foreign_key: true
      t.integer :sequence
    end
  end
end
