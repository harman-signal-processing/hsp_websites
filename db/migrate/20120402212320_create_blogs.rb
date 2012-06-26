class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :name
      t.integer :brand_id
      t.integer :default_article_id

      t.timestamps
    end
  end
end
