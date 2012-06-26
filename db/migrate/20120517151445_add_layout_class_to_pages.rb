class AddLayoutClassToPages < ActiveRecord::Migration
  def change
    add_column :pages, :layout_class, :string
  end
end
