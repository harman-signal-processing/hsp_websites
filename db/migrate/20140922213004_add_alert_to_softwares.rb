class AddAlertToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :alert, :text
    add_column :softwares, :show_alert, :boolean, default: false
  end
end
