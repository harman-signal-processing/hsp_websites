class AddJsToPages < ActiveRecord::Migration
  def change
    add_column :pages, :custom_js, :text
  end
end
