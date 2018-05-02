class CreateParts < ActiveRecord::Migration[5.1]
  def change
    create_table :parts do |t|
      t.string :part_number
      t.string :description
      t.string :photo_file_name
      t.integer :photo_file_size
      t.string :photo_content_type
      t.datetime :photo_updated_at

      t.timestamps
    end
  end
end
