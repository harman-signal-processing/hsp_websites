class AddScheduleToSlideshow < ActiveRecord::Migration
  def change
  	add_column :settings, :start_on, :date
  	add_column :settings, :remove_on, :date
  end
end
