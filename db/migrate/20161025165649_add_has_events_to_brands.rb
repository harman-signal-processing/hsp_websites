class AddHasEventsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_events, :boolean, default: false
  end
end
