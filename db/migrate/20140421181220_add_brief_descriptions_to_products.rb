class AddBriefDescriptionsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :short_description_1, :string
    add_column :products, :short_description_2, :string
    add_column :products, :short_description_3, :string
    add_column :products, :short_description_4, :string
  end
end
