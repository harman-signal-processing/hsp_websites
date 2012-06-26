class CreateAudioDemos < ActiveRecord::Migration
  def change
    create_table :audio_demos do |t|
      t.string :name
      t.text :description
      t.string :wet_demo_file_name
      t.integer :wet_demo_file_size
      t.string :wet_demo_content_type
      t.datetime :wet_demo_updated_at
      t.string :dry_demo_file_name
      t.integer :dry_demo_file_size
      t.string :dry_demo_content_type
      t.datetime :dry_demo_updated_at
      t.integer :duration_in_seconds
      t.integer :brand_id

      t.timestamps
    end
  end
end
