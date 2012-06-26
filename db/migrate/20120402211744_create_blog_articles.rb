class CreateBlogArticles < ActiveRecord::Migration
  def change
    create_table :blog_articles do |t|
      t.string :title
      t.integer :blog_id
      t.date :post_on
      t.integer :author_id
      t.text :body

      t.timestamps
    end
  end
end
