class AddMailtoToSystems < ActiveRecord::Migration
  def change
    add_column :systems, :send_mail_to, :string
  end
end
