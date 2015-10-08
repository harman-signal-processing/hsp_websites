class AddLegalDisclaimerToProducts < ActiveRecord::Migration
  def change
    add_column :products, :legal_disclaimer, :text
  end
end
