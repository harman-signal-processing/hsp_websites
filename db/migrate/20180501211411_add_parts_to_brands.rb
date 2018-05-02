class AddPartsToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :has_parts_library, :boolean

    begin
      Brand.find("martin").update_column(:has_parts_library, true)
    rescue
      # blah
    end
  end
end
