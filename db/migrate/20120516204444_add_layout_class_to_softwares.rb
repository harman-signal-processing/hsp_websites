class AddLayoutClassToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :layout_class, :string
  end
end
