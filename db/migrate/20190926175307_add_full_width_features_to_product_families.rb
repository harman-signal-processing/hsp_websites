class AddFullWidthFeaturesToProductFamilies < ActiveRecord::Migration[5.2]
  def change
    add_column :product_families, :has_full_width_features, :boolean, default: false

    begin
      Brand.find("martin").product_families.update_all(has_full_width_features: true)
    rescue
      puts "You will need to edit Martin families manually. Set them all to have full width features."
    end
  end
end
