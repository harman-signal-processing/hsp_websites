class CreateSystemConfigurations < ActiveRecord::Migration
  def change
    create_table :system_configurations do |t|
      t.integer :system_id
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
