class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.references :featurable, polymorphic: true, index: true
      t.integer :position
      t.string :layout_style
      t.string :content_position
      t.text :pre_content
      t.text :content
      t.string :image_file_name
      t.string :image_content_type
      t.datetime :image_updated_at
      t.integer :image_file_size

      t.timestamps null: false
    end
  end
end
