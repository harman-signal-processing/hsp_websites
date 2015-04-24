class AddBrandToContactMessages < ActiveRecord::Migration
  def change
    add_column :contact_messages, :brand_id, :integer
    add_index :contact_messages, :brand_id
  end
end
