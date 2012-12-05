class AddCurrentVersionIdToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :current_version_id, :integer
  end
end
