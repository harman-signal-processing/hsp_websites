class AddJblVertecVtxOwnerApproverToUsers < ActiveRecord::Migration[6.1]
  def self.up
    add_column :users, :jbl_vertec_vtx_owner_approver, :boolean, default: false
  end

  def self.down
    remove_column :users, :jbl_vertec_vtx_owner_approver
  end
end
