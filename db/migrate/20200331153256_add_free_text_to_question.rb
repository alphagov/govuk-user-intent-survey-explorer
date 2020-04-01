class AddFreeTextToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :free_text_response, :boolean
  end
end
