class AddSideContentToSoftwares < ActiveRecord::Migration[5.2]
  def change
    add_column :softwares, :side_content, :text
  end
end
