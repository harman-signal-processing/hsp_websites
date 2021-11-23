namespace :reports do

  desc "Sends download totals for a given Software"
  task software_downloads: :environment do
    SoftwareReport.find_each do |software_report|
      software_report.send_monthly_report
    end
  end

end
