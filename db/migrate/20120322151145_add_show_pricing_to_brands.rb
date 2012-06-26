class AddShowPricingToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :show_pricing, :boolean
    Brand.find_by_name("Lexicon").update_attributes(:show_pricing => true)
  end
end
