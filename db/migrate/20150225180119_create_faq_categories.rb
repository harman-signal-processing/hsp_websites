class CreateFaqCategories < ActiveRecord::Migration
  def change
    create_table :faq_categories do |t|
      t.string :name
      t.integer :brand_id
      t.timestamps
    end
    add_index :faq_categories, :brand_id
  end
end
