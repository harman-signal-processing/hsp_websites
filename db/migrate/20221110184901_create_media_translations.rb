class CreateMediaTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :media_translations do |t|
      t.string :media_type
      t.integer :media_id
      t.string :media_method
      t.string :locale
      t.string :media_file_name
      t.string :media_content_type
      t.integer :media_file_size
      t.datetime :media_updated_at

      t.timestamps
      t.index ["media_type", "media_id"], name: "index_media_translations_on_media_type_and_media_id"
      t.index ["locale"], name: "index_media_translations_on_locale"
    end
  end
end
