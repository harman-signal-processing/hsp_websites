namespace :delete_trash do
  
  task delete_trash_warranty_registrations: :environment do
    
    def write_message(log, message_to_output="", message_decoration="")
      if ENV["RAILS_ENV"] == "production"  # production doesn't have colorful puts
        puts message_to_output
      else
        puts eval(message_to_output.inspect + message_decoration)
      end
      log.info message_to_output
    end  #  def message(message)
    
    t = Time.now.localtime(Time.now.in_time_zone('America/Chicago').utc_offset)
    filename = "delete_trash_warranty_registrations.#{ENV["RAILS_ENV"]}.#{t.month}.#{t.day}.#{t.year}_#{t.strftime("%I.%M.%S_%p")}.log"
    log = ActiveSupport::Logger.new("log/#{filename}")
    start_time = Time.now
    
    # !!!!!!!!!!!!!!!!!!
    # If true we really make updates to the database. If false we do not make updates to the database, we only do reads and output statuses.
    really_run = true
    # !!!!!!!!!!!!!!!!!!

    write_message(log, "")
    write_message(log, "Running in #{ENV["RAILS_ENV"]}")
    write_message(log, "Making database updates: #{really_run}")
    write_message(log, "") # line break

# THIS IS WHERE THE WORK WILL BE DONE

    registrations_to_delete = WarrantyRegistration.where("first_name like '%http:%' or last_name like '%http:%' or first_name like '%https:%' or last_name like '%https:%'")
    
    write_message(log, "Preparing to delete #{registrations_to_delete.count} trash records.")
    
    registrations_to_delete.each do |item|
      write_message(log, "deleting first_name: #{item.first_name}, last_name: #{item.last_name}")
      write_message(log, "") # line break
    end
    
    registrations_to_delete.destroy_all
    
    write_message(log, "-----done-----")


    end_time = Time.now
    duration = ((end_time - start_time) / 1.minute).truncate(2)

    end_time_formatted = "#{end_time.month}/#{end_time.day}/#{end_time.year} #{end_time.strftime("%I:%M:%S %p")}"

    write_message(log, "Task finished at #{end_time_formatted} and lasted #{duration} minutes.")    
    
  end  #  task delete_trash_warranty_registrations: :environment do
end  #  namespace :delete_trash do