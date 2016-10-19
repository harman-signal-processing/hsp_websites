class CreateGetStartedPageProducts < ActiveRecord::Migration
  def change
    create_table :get_started_page_products do |t|
      t.integer :get_started_page_id
      t.integer :product_id

      t.timestamps null: false
    end
    add_index :get_started_page_products, :get_started_page_id
    add_index :get_started_page_products, :product_id
  end
end
