class AddApprovalToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :approver_id, :integer
  end

  def self.down
    remove_column :artists, :approver_id
  end
end
