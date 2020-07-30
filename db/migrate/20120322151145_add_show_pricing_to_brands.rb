class AddShowPricingToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :show_pricing, :boolean
    Brand.where(name: "Lexicon").first.update(:show_pricing => true)
  end
end
