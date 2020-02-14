class CreateEventVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :event_visits do |t|
      t.references :event, null: false, foreign_key: true
      t.references :visit, null: false, foreign_key: true
      t.integer :sequence
    end
  end
end
