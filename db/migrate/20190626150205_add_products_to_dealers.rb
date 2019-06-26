class AddProductsToDealers < ActiveRecord::Migration[5.2]
  def change
    add_column :dealers, :products, :string
  end
end
