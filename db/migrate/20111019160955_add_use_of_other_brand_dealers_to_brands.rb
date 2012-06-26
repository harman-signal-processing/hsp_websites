class AddUseOfOtherBrandDealersToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :dealers_from_brand_id, :integer
    add_column :brands, :distributors_from_brand_id, :integer
  end

  def self.down
    remove_column :brands, :distributors_from_brand_id
    remove_column :brands, :dealers_from_brand_id
  end
end
