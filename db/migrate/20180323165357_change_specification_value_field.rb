class ChangeSpecificationValueField < ActiveRecord::Migration[5.1]
  def up
    change_column :product_specifications, :value, :text
  end

  def down
    change_column :product_specifications, :value, :string
  end
end
