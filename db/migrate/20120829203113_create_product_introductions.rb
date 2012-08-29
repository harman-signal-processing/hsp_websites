class CreateProductIntroductions < ActiveRecord::Migration
  def change
    create_table :product_introductions do |t|
      t.integer :product_id
      t.string :layout_class
      t.date :expires_on
      t.text :content
      t.text :extra_css

      t.timestamps
    end
  end
end
