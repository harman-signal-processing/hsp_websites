class AddCommentToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :comment, :string
  end

  def self.down
    remove_column :websites, :comment
  end
end
