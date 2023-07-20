class ChangeSoftwareFileSizeToBigint < ActiveRecord::Migration[7.0]
  def up
    change_column :softwares, :ware_file_size, :bigint
  end

  def down
    change_column :softwares, :ware_file_size, :int
  end
end
