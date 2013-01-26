class AddIntlToPricingTypes < ActiveRecord::Migration
  def change
    add_column :pricing_types, :us, :boolean
    add_column :pricing_types, :intl, :boolean
  end
end
