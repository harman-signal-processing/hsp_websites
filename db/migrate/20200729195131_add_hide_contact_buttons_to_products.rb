class AddHideContactButtonsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :hide_contact_buttons, :boolean
  end
end
