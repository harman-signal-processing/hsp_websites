class CreateLocales < ActiveRecord::Migration[7.0]
  def change
    create_table :locales do |t|
      t.string :code, limit: 12
      t.string :name

      t.timestamps
    end
    add_index :locales, :code

    rename_column :website_locales, :name, :original_name

    WebsiteLocale.all.each do |wl|
      locale = Locale.where(code: wl.locale).first_or_create
      locale.update(name: wl.original_name)
    end

    remove_column :website_locales, :original_name

    Locale.where(code: "en-asia").update(name: "English (Asia)")
    Locale.where(code: "en-US").update(name: "English (US)")
    Locale.where(code: "zh").update(name: "中文 (Chinese)")
    Locale.where(code: "fr").update(name: "Français (French)")
    Locale.where(code: "es").update(name: "Español (Spanish)")
    Locale.where(code: "id").update(name: "Bahasa (Indonesia)")
    Locale.where(code: "de").update(name: "Deutsch (German)")
    Locale.where(code: "vi").update(name: "Tiếng Việt (Vietnamese)")

    WebsiteLocale.where(complete: false).delete_all
  end
end
