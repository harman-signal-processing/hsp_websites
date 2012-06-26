class AddCustomCssToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :custom_css, :text
  end

  def self.down
    remove_column :pages, :custom_css
  end
end
