class AddShowSolutionsFlagsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :show_enterprise_solutions, :boolean
    add_column :brands, :show_entertainment_solutions, :boolean
  end
end
