class AddLongDescriptionToSystemOptions < ActiveRecord::Migration
  def change
    add_column :system_options, :long_description, :text
  end
end
