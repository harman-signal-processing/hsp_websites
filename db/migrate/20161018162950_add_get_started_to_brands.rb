class AddGetStartedToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_get_started_pages, :boolean, default: false
  end
end
