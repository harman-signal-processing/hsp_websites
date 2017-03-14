class AddRegistrationNoticeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :registration_notice, :text
  end
end
