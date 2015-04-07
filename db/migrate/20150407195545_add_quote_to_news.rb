class AddQuoteToNews < ActiveRecord::Migration
  def change
    add_column :news, :quote, :text
  end
end
