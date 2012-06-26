class CreateWebsiteLocales < ActiveRecord::Migration
  def self.up
    create_table :website_locales do |t|
      t.integer :website_id
      t.string :locale
      t.string :name
      t.boolean :complete, :default => false
      t.boolean :default, :default => false

      t.timestamps
    end
    Website.all.each do |ws|
      WebsiteLocale.create(:website_id => ws.id, :locale => "en", :name => "English", :complete => true)
      WebsiteLocale.create(:website_id => ws.id, :locale => "en-US", :name => "English/USA", :complete => true, :default => true)
    end
  end

  def self.down
    drop_table :website_locales
  end
end
