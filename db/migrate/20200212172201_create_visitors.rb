class CreateVisitors < ActiveRecord::Migration[6.0]
  def change
    create_table :visitors do |t|
      t.string :intent_client_id
      t.string :ga_primary_key
      t.numeric :ga_full_visitor_id

      t.timestamps
    end
  end
end
