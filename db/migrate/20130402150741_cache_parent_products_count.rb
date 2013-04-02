class CacheParentProductsCount < ActiveRecord::Migration
  def up
  	execute "update products set parent_products_count=(select count(*) from parent_products where product_id=products.id)"
  end

  def down
  end
end
