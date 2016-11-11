class AddPositionToBrandSolutionFeaturedProducts < ActiveRecord::Migration
  def change
    add_column :brand_solution_featured_products, :position, :integer
  end
end
