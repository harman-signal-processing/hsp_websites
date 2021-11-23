class SoftwareReportSubscription < ApplicationRecord
  belongs_to :software_report
  belongs_to :user
end
