class AddHiddenContentToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :hidden_content, :text
  end
end
