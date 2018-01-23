class AddInternationalToDealers < ActiveRecord::Migration[5.1]
  def change
    add_column :dealers, :google_map_place_id, :string
    add_column :dealers, :country, :string
    add_column :dealers, :resale, :boolean, default: true
    add_column :dealers, :rush, :boolean, default: false
    add_column :dealers, :rental, :boolean, default: false
    add_column :dealers, :installation, :boolean, default: false
    add_column :dealers, :represented_in_country, :string
    add_column :dealers, :service, :boolean, default: false
  end
end
