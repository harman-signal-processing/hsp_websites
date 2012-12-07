class AddBitToSoftwares < ActiveRecord::Migration
  def up
    add_column :softwares, :bit, :string
    Software.where("category LIKE '%gui%'").update_all(category: 'gui')
  end

  def down
  	remove_column :softwares, :bit
  end
end
