class AddRegionToDealers < ActiveRecord::Migration[5.2]
  def change
    add_column :dealers, :region, :string
    add_index :dealers, :region
  end
end
