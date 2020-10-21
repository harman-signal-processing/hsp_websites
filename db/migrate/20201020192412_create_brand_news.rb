class CreateBrandNews < ActiveRecord::Migration[6.0]
  def up
    create_table :brand_news do |t|
      t.integer :brand_id
      t.integer :news_id

      t.timestamps
    end
    add_index :brand_news, :brand_id
    add_index :brand_news, :news_id

    News.all.each do |news|
      BrandNews.where(news_id: news.id, brand_id: news.brand_id).first_or_create
    end

    remove_column :news, :brand_id
  end

  def down
    add_column :news, :brand_id, :integer
    add_index :news, :brand_id

    BrandNews.all.each do |brand_news|
      News.where(id: brand_news.news_id).update(brand_id: brand_news.brand_id)
    end

    drop_table :brand_news
  end
end
