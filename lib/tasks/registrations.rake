namespace :registration do
  
  desc "export new warranty registrations"
  task :export_new => :environment do
    all = File.open(Rails.root.join("..", "..", "all_registrations.txt"), "a")
    File.open(Rails.root.join("..", "..", "new_registrations.txt"), "w+") do |fh|
      WarrantyRegistration.where(:exported => false).each do |reg|
        fh.puts reg.to_export
        all.puts reg.to_export
        reg.update_attributes(:exported => true)
      end
    end
    all.close
  end
  
end