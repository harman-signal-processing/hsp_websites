class RemoveProductIntroductions < ActiveRecord::Migration[7.0]
  def change
    drop_table :product_introductions
  end
end
