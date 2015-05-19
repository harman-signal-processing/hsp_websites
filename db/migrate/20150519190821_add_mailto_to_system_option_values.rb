class AddMailtoToSystemOptionValues < ActiveRecord::Migration
  def change
    add_column :system_option_values, :send_mail_to, :string
  end
end
