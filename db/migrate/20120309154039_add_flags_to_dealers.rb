class AddFlagsToDealers < ActiveRecord::Migration
  def change
    add_column :dealers, :exclude, :boolean
    add_column :dealers, :skip_sync_from_sap, :boolean
    Dealer.all.each do |dealer|
      if dealer.updated_at > dealer.created_at
        dealer.update_attributes(:skip_sync_from_sap => true)
      end
    end
  end
end
