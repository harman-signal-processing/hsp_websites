class DropTableAmpModel < ActiveRecord::Migration[6.1]
  def change
    drop_table :amp_models
    drop_table :product_amp_models
  end
end
