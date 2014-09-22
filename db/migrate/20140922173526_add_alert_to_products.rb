class AddAlertToProducts < ActiveRecord::Migration
  def change
    add_column :products, :alert, :text
    add_column :products, :show_alert, :boolean, default: false
  end
end
