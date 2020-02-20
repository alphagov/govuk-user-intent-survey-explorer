class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.integer :question_number
      t.string :question_text

      t.timestamps
    end
  end
end
