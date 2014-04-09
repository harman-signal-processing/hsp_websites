class CreateMarketingCalendars < ActiveRecord::Migration
  def change
    create_table :marketing_calendars do |t|
      t.string :name

      t.timestamps
    end
  end
end
