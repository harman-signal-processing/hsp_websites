class AddTrainingUrlToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :training_url, :string
  end
end
