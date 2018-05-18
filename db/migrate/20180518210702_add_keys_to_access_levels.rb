class AddKeysToAccessLevels < ActiveRecord::Migration[5.1]
  def change
    add_column :access_levels, :keys, :integer
  end
end
