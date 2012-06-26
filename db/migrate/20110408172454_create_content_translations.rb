class CreateContentTranslations < ActiveRecord::Migration
  def self.up
    create_table :content_translations do |t|
      t.string :content_type
      t.integer :content_id
      t.string :content_method
      t.string :locale
      t.text :content

      t.timestamps
    end
    add_index :content_translations, [:content_type, :content_id, :content_method, :locale], :unique => true
    add_index :content_translations, [:content_type, :content_id, :content_method]
  end

  def self.down
    drop_table :content_translations
  end
end
