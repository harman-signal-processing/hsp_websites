require "csv"
namespace :import do

  desc "Import Studer distributors"
  task studer_distributors: :environment do
    puts "Total distributors before: #{Distributor.count}"
    studer = Brand.find("studer")

    distributors_file = Rails.root.join("db", "studer_distributors.csv")

    CSV.open(distributors_file, 'r:ISO-8859-1').each do |row|
      d = Distributor.where(name: row[3], country: row[15]).first_or_initialize
      details = []
      details << row[4] unless row[4].blank?
      details << row[5] unless row[5].blank?
      details << row[6] unless row[6].blank?
      details << row[7] unless row[7].blank?
      details << row[8] unless row[8].blank?
      details << row[9] unless row[9].blank?
      details << "<br/>"
      details << "Contact: #{row[1]}" unless row[1].blank?
      details << "Phone: #{row[10]}" unless row[10].blank?
      details << "Fax: #{row[11]}" unless row[11].blank?
      details << "email: <a href='mailto:#{row[12]}'>#{row[12]}</a>" unless row[12].blank?
      details << "<a href='#{row[14]}' target='_blank'>#{row[14]}</a>" unless row[14].blank?
      d.detail ||= details.join("<br/>")
      d.email ||= row[12]
      d.account_number ||= row[0]

      if d.save
        unless d.brands.include?(studer)
          d.brands << studer
        end
      end

      studer.update_attributes(distributors_from_brand_id: nil)
    end

    puts "Studer distributor count: #{studer.distributors.length}"
    puts "Total distributors after: #{Distributor.count}"
  end
end
