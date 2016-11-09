class AddHasSolutionsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_solution_pages, :boolean, default: false
  end
end
