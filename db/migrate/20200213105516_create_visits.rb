class CreateVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :visits do |t|
      t.references :visitor, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true
      t.bigint :ga_visit_id
      t.integer :ga_visit_number
      t.datetime :ga_visit_start_at
      t.datetime :ga_visit_end_at

      t.timestamps
    end
  end
end
