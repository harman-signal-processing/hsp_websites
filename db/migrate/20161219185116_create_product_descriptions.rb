class CreateProductDescriptions < ActiveRecord::Migration
  def up
    create_table :product_descriptions, force: true do |t|
      t.integer :product_id
      t.string :content_name
      t.text :content_part1
      t.text :content_part2

      t.timestamps null: false
    end
    add_index :product_descriptions, :product_id
    add_index :product_descriptions, :content_name

    Product.all.each do |product|
      d = ProductDescription.where(product_id: product.id, content_name: "description").first_or_initialize
      d.content = Product.where(id: product.id).pluck(:description).first
      d.save

      e = ProductDescription.where(product_id: product.id, content_name: "extended_description").first_or_initialize
      e.content = Product.where(id: product.id).pluck(:extended_description).first
      e.save

      f = ProductDescription.where(product_id: product.id, content_name: "features").first_or_initialize
      f.content = Product.where(id: product.id).pluck(:features).first
      f.save
    end

    remove_column :products, :description
    remove_column :products, :extended_description
    remove_column :products, :features
  end

  def down
    add_column :products, :description, :text
    add_column :products, :extended_description, :text
    add_column :products, :features, :text

    ProductDescription.all.each do |pd|
      product = Product.find(pd.product_id)
      product.update_column(pd.content_name, pd.content_part1)
    end

    drop_table :product_descriptions
  end
end
