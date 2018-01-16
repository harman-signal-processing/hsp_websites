class AddPhotometricIdToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :photometric_id, :string
  end
end
