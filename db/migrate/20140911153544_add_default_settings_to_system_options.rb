class AddDefaultSettingsToSystemOptions < ActiveRecord::Migration
  def change
    add_column :system_options, :default_value, :string
    add_column :system_options, :show_on_first_screen, :boolean, default: false
  end
end
