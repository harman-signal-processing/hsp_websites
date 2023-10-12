class CreateBannerLocales < ActiveRecord::Migration[7.0]
  def change
    create_table :banner_locales do |t|
      t.references :banner, null: false, foreign_key: true
      t.string :locale, null: false
      t.integer :position

      t.timestamps
    end

    add_index :banner_locales, :locale
  end
end
