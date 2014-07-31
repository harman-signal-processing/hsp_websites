class AddHomepageHeadlineAndTextToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :homepage_headline, :string
    add_column :promotions, :homepage_text, :text
  end
end
