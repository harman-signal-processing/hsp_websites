class AddExcludeFromSearchToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :exclude_from_search, :boolean, default: false
  end
end
