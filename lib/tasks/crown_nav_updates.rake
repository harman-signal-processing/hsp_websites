namespace :crown_nav do
  desc "Updates for the crown nav"
  task :update_nav => :environment do
    # BEGIN TASK METHOD DEFINITIONS
        def crown
          crown = Brand.find "crown"
        end

        def create_new_product_families(log, really_run)

          write_message(log, "-------------CREATING #{new_product_families_to_create.count} NEW PRODUCT FAMILIES------------------")

          new_product_families_to_create.each do |pf|

            grand_parent = pf[:grand_parent_slug].present? ? ProductFamily.where(brand: crown, cached_slug: pf[:grand_parent_slug]).first : ProductFamily.where(brand: crown, name: pf[:grand_parent]).first
            parent = pf[:parent_slug].present? ? ProductFamily.where(brand: crown, cached_slug: pf[:parent_slug]).first : ProductFamily.where(brand: crown, name: pf[:parent]).first

            if parent.present? && grand_parent.present?
              begin
                new_parent = ProductFamily.where(id: parent.id, parent_id: grand_parent.id).first
              rescue => e
                write_message(log, "Issue1: #{pf}")
                write_message(log, "Error: #{e.message}", ".red")
              end

            else
              if parent.present?
                begin
                  new_parent = ProductFamily.where(id: parent.id).first
                rescue => e
                  write_message(log, "Issue2: #{pf}")
                  write_message(log, "Error: #{e.message}", ".red")
                end
              end
            end

            new_family_name = pf[:name]
            parent_to_use = new_parent.present? ? new_parent : parent

            if really_run
              new_pf = ProductFamily.create(name: new_family_name, brand: crown, parent: parent_to_use)
              new_pf.update(position: pf[:position]) if pf[:position].present?

              if parent_to_use.present?
                write_message(log, "Created #{new_family_name} [#{new_pf.cached_slug}] (#{parent_to_use.name}) [#{parent_to_use.cached_slug}]", ".green")
              else
                write_message(log, "Created #{new_family_name} [#{new_pf.cached_slug}] ()", ".green")
              end
            end  #  if really_run

          end  #  new_product_families_to_create.each do |pf|
        end  #  def create_new_product_families(log, really_run)

        def new_product_families_to_create
          # Note some parent product family names will change in step 2, the renaming is completed. Example: CDi DriveCore Series Amps will become CDi DriveCore Series
          [
            # nil | CDi DriveCore Series Amps | CDi DriveCore Series- Analog
            { name: "CDi DriveCore Series- Analog", parent: "CDi DriveCore Series Amps", parent_slug: "cdi-drivecore-series-amps", position: 1},
            # nil | CDi DriveCore Series Amps | CDi DriveCore Series- BLU Link
            { name: "CDi DriveCore Series- BLU Link", parent: "CDi DriveCore Series Amps", parent_slug: "cdi-drivecore-series-amps", position: 2}

          ]
        end  #  def new_product_families_to_create

        def rename_product_families(log, really_run)
          write_message(log, "-------------RENAMING #{product_families_to_rename.count} EXISTING PRODUCT FAMILIES------------------")

          product_families_to_rename.each do |pf|
            grand_parent = pf[:grand_parent_slug].present? ? ProductFamily.where(cached_slug: pf[:grand_parent_slug]) : ProductFamily.where(name: pf[:grand_parent])
            parent = pf[:parent_slug].present? ? ProductFamily.where(cached_slug: pf[:parent_slug]) : ProductFamily.where(name: pf[:parent])

            if grand_parent.present?
              new_parent = ProductFamily.where(id: parent.ids, parent_id: grand_parent.ids).first
            else
              new_parent = ProductFamily.where(id: parent.ids).first
            end
            product_family_to_rename = pf[:old_slug].present? ? ProductFamily.where(name: pf[:old_slug], brand_id: crown.id).first : ProductFamily.where(name: pf[:old], brand_id: crown.id).first

            if product_family_to_rename.present?

              old_pf_name = product_family_to_rename.name
              old_pf_slug = product_family_to_rename.cached_slug
              product_family_to_rename.name = pf[:new]
              product_family_to_rename.position = pf[:position] if pf[:position].present?

                if new_parent.present?
                  begin
                    product_family_to_rename.parent = new_parent
                  rescue => e
                    write_message(log, "Error changing pf parent: #{e.message}", ".red")
                  end
                end

              if really_run
                product_family_to_rename.save
              end

              write_message(log, "#{old_pf_name} [#{old_pf_slug}] renamed --> #{pf[:new]} [#{product_family_to_rename.cached_slug}]", ".green")

            end  #  if product_family_to_rename.present?

          end  #  product_families_to_rename.each do |pf|

        end  #  def rename_product_families
        def product_families_to_rename
          [
            { old: "DCi Series", new: "DCi DriveCore Series", parent: nil, position: 1},
            { old: "CDi DriveCore Series Amps", new: "CDi DriveCore Series", parent: nil, position: 3},
            { old: "I-Tech HD Series", new: "i-Tech", parent: nil, position: 9}

          ]
        end  #  def product_families_to_rename

        def delete_old_product_families(log, really_run)
          slugs = [
            '',
            '',
            ''
            ]

          write_message(log, "-------------DELETING #{slugs.count} OLD PRODUCT FAMILIES------------------")

          slugs.each do |slug|
            product_familiy_to_delete = ProductFamily.where(cached_slug: slug).first

            if product_familiy_to_delete.present?

                begin
                  parent = ProductFamily.where(id: product_familiy_to_delete.parent_id).first
                rescue => e
                  write_message(log, "Error finding parent pf in deletion process:  #{e.message}", ".red")
                end
                if parent.present?
                  write_message(log, "Deleting #{product_familiy_to_delete.name} (#{parent.name})", ".yellow")
                else
                  write_message(log, "Deleting #{product_familiy_to_delete.name}", ".yellow")
                end

                if really_run
                  product_familiy_to_delete.destroy
                end
            end  #  if product_familiy_to_delete.present?

          end  #  slugs.each do |slug|

        end  #  def delete_old_product_families(log, really_run)

        def reassign_product_families(log, really_run)
          # these are reassignments are necessary due to the rare occasions when the order of creation and renaming existing product families falls short
          pfs = [
            {slug:"amplifiers-c402ccb1-3c40-4861-a35d-27b1b0c9fd53",parent_slug: nil, grand_parent_slug: nil},
            {slug:"mixer-amplifiers",parent_slug: nil, grand_parent_slug: nil},
            {slug:"mixers",parent_slug: nil, grand_parent_slug: nil}
            ]

            write_message(log, "-------------REPARENTING #{pfs.count} PRODUCT FAMILIES------------------")

            pfs.each do |item|
              grand_parent = ProductFamily.where(cached_slug: item[:grand_parent_slug])
              parent = ProductFamily.where(cached_slug: item[:parent_slug])
              pf = ProductFamily.where(cached_slug: item[:slug]).first

              if grand_parent.present?
                new_parent = ProductFamily.where(id: parent.ids, parent_id: grand_parent.ids).first
              else
                new_parent = ProductFamily.where(id: parent.ids).first
              end

              pf.parent = new_parent
              pf.position = item[:position] if item[:position].present?
              if really_run
                pf.save
                pf.update_current_product_counts
                # pf.has_current_products?(Website.find(66))
                # binding.pry if pf.cached_slug == "mixer-amplifiers"
              end
              if new_parent.nil?
                write_message(log, "Reassigned #{pf.name} (#{pf.cached_slug}) to ---> top level (no parent)", ".green")
              else
                write_message(log, "Reassigned #{pf.name} (#{pf.cached_slug}) to ---> #{new_parent.name} (#{new_parent.cached_slug})", ".green")
              end
            end  #  pfs.each do |item|

        end  #  def reassign_product_families(log)

        def change_product_product_family(log, really_run)
          write_message(log, "-------------CHANGING PRODUCT FAMILIES FOR #{product_product_families_to_change.count} EXISTING PRODUCTS------------------")

          product_product_families_to_change.each do |p|

            product = p[:product_slug].present? ? Product.where(brand: crown, cached_slug: p[:product_slug]).first : Product.where(brand: crown, name: p[:product_name]).first
            product_family_to_remove = p[:remove_from_product_family_slug].present? ? ProductFamily.where(brand: crown, cached_slug: p[:remove_from_product_family_slug]).first : ProductFamily.where(brand: crown, name: p[:remove_from_product_family]).first
            new_product_family = p[:new_product_family_slug].present? ? ProductFamily.where(brand: crown, cached_slug: p[:new_product_family_slug]).first : ProductFamily.where(brand: crown, name: p[:new_product_family]).first
            grand_parent_product_family = p[:grand_parent_product_family_slug].present? ? ProductFamily.where(brand: crown, cached_slug: p[:grand_parent_product_family_slug]).first : ProductFamily.where(brand: crown, name: p[:grand_parent_product_family]).first


            if product.present? && product_family_to_remove.present?
              write_message(log, "Removing #{product.name} from --xxx #{product_family_to_remove.name}", ".yellow")
              if really_run
                product.product_family_products.where(product_family: product.product_families.find_by_name(product_family_to_remove.name)).delete_all
              end
            end

            # if grand_parent_product_family.present?
            #   begin
            #     new_family_name = ProductFamily.where(id: new_product_family.id, parent_id: grand_parent_product_family.id).first
            #   rescue => e
            #     binding.pry
            #     puts "Error finding grand parent family #{grand_parent_product_family.name}: #{e.message}".red
            #   end
            # end

            if product.present? && new_product_family.present?

              if grand_parent_product_family.present?
                begin
                  write_message(log, "Adding #{product.name} to ---> #{new_product_family.name} [#{new_product_family.cached_slug}] (#{grand_parent_product_family.name} [#{grand_parent_product_family.cached_slug}])", ".green")
                rescue => e
                  write_message(log, "Error adding #{product.name} to family with family parent: #{e.message}", ".red")
                end
              else
                begin
                  write_message(log, "Adding #{product.name} to ---> #{new_product_family.name} [#{new_product_family.cached_slug}]", ".green")
                rescue => e
                  write_message(log, "Error adding #{product.name} to family: #{e.message}", ".red")
                end
              end

              begin
                if really_run
                  ProductFamilyProduct.create(product: product, product_family: new_product_family)
                end
              rescue => e
                write_message(log, "Error creating: #{e.message}", ".red")
              end
            end

          end  #  product_product_families_to_change.each do |p|

        end  #  def change_product_product_family(log, really_run)

        def product_product_families_to_change
          # change product family for these products
          [
            { product_name: "135MA",   product_slug: "135ma", remove_from_product_family: "Mixer-Amplifiers",                  remove_from_product_family_slug: "mixer-amplifiers",         new_product_family: "Commercial Series",                            new_product_family_slug: "commercial-series",             grand_parent_product_family: nil,                     grand_parent_product_family_slug: nil },
            { product_name: "160MA",   product_slug: "160ma", remove_from_product_family: "Mixer-Amplifiers",                  remove_from_product_family_slug: "mixer-amplifiers",         new_product_family: "Commercial Series",                            new_product_family_slug: "commercial-series",             grand_parent_product_family: nil,                     grand_parent_product_family_slug: nil },
            { product_name: "CDi 2|300",   product_slug: "cdi-2-300", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series",     new_product_family: "CDi DriveCore Series- Analog",                 new_product_family_slug: "cdi-drivecore-series-analog",   grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 4|300",   product_slug: "cdi-4-300", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series",     new_product_family: "CDi DriveCore Series- Analog",                 new_product_family_slug: "cdi-drivecore-series-analog",   grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 2|600",   product_slug: "cdi-2-600", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series",     new_product_family: "CDi DriveCore Series- Analog",                 new_product_family_slug: "cdi-drivecore-series-analog",   grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 4|600",   product_slug: "cdi-4-600", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series",     new_product_family: "CDi DriveCore Series- Analog",                 new_product_family_slug: "cdi-drivecore-series-analog",   grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 2|1200",   product_slug: "cdi-2-1200", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series",   new_product_family: "CDi DriveCore Series- Analog",                 new_product_family_slug: "cdi-drivecore-series-analog",   grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 4|1200",   product_slug: "cdi-4-1200", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series",   new_product_family: "CDi DriveCore Series- Analog",                 new_product_family_slug: "cdi-drivecore-series-analog",   grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 2|300BL",   product_slug: "cdi-2-300bl", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series", new_product_family: "CDi DriveCore Series- BLU Link",               new_product_family_slug: "cdi-drivecore-series-blu-link", grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 4|300BL",   product_slug: "cdi-4-300bl", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series", new_product_family: "CDi DriveCore Series- BLU Link",               new_product_family_slug: "cdi-drivecore-series-blu-link", grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 4|600BL",   product_slug: "cdi-4-600bl", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series", new_product_family: "CDi DriveCore Series- BLU Link",               new_product_family_slug: "cdi-drivecore-series-blu-link", grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 2|600BL",   product_slug: "cdi-2-600bl", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series", new_product_family: "CDi DriveCore Series- BLU Link",               new_product_family_slug: "cdi-drivecore-series-blu-link", grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 2|1200BL",   product_slug: "cdi-2-1200bl", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series", new_product_family: "CDi DriveCore Series- BLU Link",               new_product_family_slug: "cdi-drivecore-series-blu-link", grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" },
            { product_name: "CDi 4|1200BL",   product_slug: "cdi-4-1200bl", remove_from_product_family: "CDi DriveCore Series",      remove_from_product_family_slug: "cdi-drivecore-series", new_product_family: "CDi DriveCore Series- BLU Link",               new_product_family_slug: "cdi-drivecore-series-blu-link", grand_parent_product_family: "CDi DriveCore Series",  grand_parent_product_family_slug: "cdi-drivecore-series" }

          ]
        end  #  def product_product_families_to_change

        def reorder_product_families(log, really_run)
          pfs = [
            {slug:"dci-drivecore-series", position: 1},
            {slug:"commercial-series", position: 2},
            {slug:"cdi-drivecore-series", position: 3},
            {slug:"comtech-drivecore-series", position: 4},
            {slug:"xlc-series", position: 5},
            {slug:"xli-series", position: 6},
            {slug:"xls-drivecore-2-series", position: 7},
            {slug:"xti-2-series", position: 8},
            {slug:"i-tech", position: 9},
            {slug:"vrack", position: 10},
            {slug:"amp-accessories", position: 11}
            ]

            write_message(log, "-------------REORDERING #{pfs.count} PRODUCT FAMILIES------------------")

            pfs.each do |item|
              pf = ProductFamily.where(cached_slug: item[:slug]).first
              pf.position = item[:position] if item[:position].present?
              if really_run
                pf.save
                pf.update_current_product_counts
              end  #  if really_run

              write_message(log, "Reordered #{pf.name} (#{pf.cached_slug}) to ---> #{pf.position}", ".green")
            end  #  pfs.each do |item|

        end  #  def reorder_product_families(log, really_run)

        def write_message(log, message_to_output="", message_decoration="")
          if ENV["RAILS_ENV"] == "production"  # production doesn't have colorful puts
            puts message_to_output
          else
            puts eval(message_to_output.inspect + message_decoration)
          end
          log.info message_to_output
        end  #  def message(message)

    # END TASK METHOD DEFINITIONS
    
    # TASK WORK BEGINS HERE AND CAN CALL THE METHODS DEFINED ABOVE WITHOUT WORRY OF THE METHODS BEING ADDED TO THE GLOBAL NAMESPACE
    t = Time.now.localtime(Time.now.in_time_zone('America/Chicago').utc_offset)
    filename = "crown_product_nav_update.#{t.month}.#{t.day}.#{t.year}_#{t.strftime("%I.%M.%S_%p")}.log"
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

    # do stuff
    create_new_product_families(log, really_run)
    rename_product_families(log, really_run)
    change_product_product_family(log, really_run)
    reassign_product_families(log, really_run)
    reorder_product_families(log, really_run)

    write_message(log, "")

    end_time = Time.now
    duration = ((end_time - start_time) / 1.minute).truncate(2)

    end_time_formatted = "#{end_time.month}/#{end_time.day}/#{end_time.year} #{end_time.strftime("%I:%M:%S %p")}"

    write_message(log, "Task finished at #{end_time_formatted} and lasted #{duration} minutes.")

  end  #  task :update_nav => :environment do
end  #  namespace :crown_nav do