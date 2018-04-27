# General Data Protection Regulation tasks

namespace :gdpr do

  desc "Remove warranty registrations that are older than 10 years (warranty period + 5 years)"
  task :trim_warranty_registrations => :environment do
    puts "Registrations before: #{ WarrantyRegistration.count }"
    WarrantyRegistration.where("updated_at < ?", 10.years.ago).delete_all
    puts "Registrations after: #{ WarrantyRegistration.count }"
  end

end
