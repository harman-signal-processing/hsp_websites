class AddProductHeaderTosolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :product_header, :string
  end
end
