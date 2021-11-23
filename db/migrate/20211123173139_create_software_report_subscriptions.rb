class CreateSoftwareReportSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :software_report_subscriptions do |t|
      t.integer :software_report_id
      t.integer :user_id

      t.timestamps
    end
    add_index :software_report_subscriptions, :software_report_id
    add_index :software_report_subscriptions, :user_id

    begin
      user = User.find(4494)
      software_report = SoftwareReport.last
      software_report.users << user
    rescue
      puts "Couldn't create initial subscription"
    end
  end
end
