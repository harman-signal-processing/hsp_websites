class ChangeHomepageColumnNames < ActiveRecord::Migration
  def up
    Setting.where(:name => "homepage_left_column").each do |col|
      col.update_attributes(:name => "homepage_column_one")
    end
    Setting.where(:name => "homepage_middle_column").each do |col|
      col.update_attributes(:name => "homepage_column_two")
    end
    Setting.where(:name => "homepage_right_column").each do |col|
      col.update_attributes(:name => "homepage_column_three")
    end
  end

  def down
    Setting.where(:name => "homepage_column_one").each do |col|
      col.update_attributes(:name => "homepage_left_column")
    end
    Setting.where(:name => "homepage_column_two").each do |col|
      col.update_attributes(:name => "homepage_middle_column")
    end
    Setting.where(:name => "homepage_column_three").each do |col|
      col.update_attributes(:name => "homepage_right_column")
    end
  end
end
