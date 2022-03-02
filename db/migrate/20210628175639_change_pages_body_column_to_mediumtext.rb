class ChangePagesBodyColumnToMediumtext < ActiveRecord::Migration[6.1]
  def change
    change_column :pages, :body, :mediumtext
  end
end
