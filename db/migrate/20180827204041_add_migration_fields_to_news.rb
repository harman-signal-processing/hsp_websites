class AddMigrationFieldsToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :video_ids, :string
    add_column :news, :old_id, :string
    add_index :news, :old_id
  end
end
