class CreateDownloadRegistrations < ActiveRecord::Migration
  def self.up
    create_table :download_registrations do |t|
      t.integer :registered_download_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :serial_number
      t.integer :download_count
      t.string :download_code

      t.timestamps
    end
  end

  def self.down
    drop_table :download_registrations
  end
end
