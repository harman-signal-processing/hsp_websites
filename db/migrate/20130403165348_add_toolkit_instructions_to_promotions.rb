class AddToolkitInstructionsToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :toolkit_instructions, :text
  end
end
