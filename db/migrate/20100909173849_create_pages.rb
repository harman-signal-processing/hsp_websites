class CreatePages < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :pages, :options => options do |t|
      t.string :title
      t.string :keywords
      t.text :description
      t.text :body
      t.string :custom_route

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
