class AddSystemConfigToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_system_configurator, :boolean, default: false
    Brand.find('bss').update_attributes(has_system_configurator: true)
  end
end
