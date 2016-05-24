class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.integer :brand_id
      t.string :title
      t.string :keywords
      t.text :description
      t.text :body
      t.string :custom_route
      t.string :cached_slug
      t.text :custom_css
      t.string :layout_class

      t.timestamps null: false
    end
    add_index :installations, :brand_id
  end
end
