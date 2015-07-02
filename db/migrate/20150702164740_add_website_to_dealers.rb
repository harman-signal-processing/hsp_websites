class AddWebsiteToDealers < ActiveRecord::Migration
  def change
    add_column :dealers, :website, :string
  end
end
