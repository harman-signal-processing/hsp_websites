class AddBigBoxToUsReps < ActiveRecord::Migration
  def change
    add_column :us_reps, :contacts, :text
  end
end
