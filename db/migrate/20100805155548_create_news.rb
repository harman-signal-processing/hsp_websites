class CreateNews < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :news, :options => options do |t|
      t.date :post_on
      t.string :title
      t.text :body
      t.text :keywords
      t.string :news_photo_file_name
      t.integer :news_photo_file_size
      t.datetime :news_photo_created_at
      t.string :news_photo_content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
