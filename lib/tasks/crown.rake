namespace :crown do

  desc "Rearrange product heirarchy (1x use)"
  task :fixup_products => :environment do
    brand = Brand.find("crown")

    begin
      amps = brand.product_families.where(name: "Amplifiers", parent_id: nil).first
      ProductFamily.where(parent_id: amps.id).each do |pf|
        pf.update_column(:parent_id, nil)
      end
      amps.destroy
    rescue
      puts "Top-level amplifiers family not found."
    end

    begin
      cinema = brand.product_families.where(name: "Cinema", parent_id: nil).first
      ProductFamily.where(parent_id: cinema.id).each do |pf|
        pf.destroy
      end
      cinema.destroy

      cinema_market = brand.market_segments.find("cinema")
      cinema_market.product_families << ProductFamily.find("drivecore-install-series-analog")
      cinema_market.product_families << ProductFamily.find("drivecore-install-series-network")
      cinema_market.product_families << ProductFamily.find("xlc-series")
      cinema_market.save
    rescue
      puts "Problem with top-level cinema family."
    end

    begin
      tour = brand.product_families.where(name: "Tour Sound", parent_id: nil).first
      tour.destroy
    rescue
      puts "Problem with top-level tour family."
    end

    begin
      portable = brand.product_families.where(name: "Portable PA", parent_id: nil).first
      portable.destroy
    rescue
      puts "Problem with top-level portable family."
    end

    begin
      install = brand.product_families.where(name: "Installed Sound", parent_id: nil).first
      ProductFamily.where(parent_id: install.id).each do |pf|
        pf.destroy
      end
      install.destroy
    rescue
      puts "Problem with top-level install family."
    end

    begin
      commercial_series = brand.product_families.where(name: "Commercial Series", parent_id: nil).first
      commercial_series.destroy
      brand.product_families.where(name: "JBL Commercial Series").destroy_all

      commercial_market = MarketSegment.where(name: "Commercial", brand_id: brand.id).first_or_create
      commercial_family = brand.product_families.where(name: "Commercial", parent_id: nil).first
      commercial_family.update_attributes(name: "Commercial Series")
      ProductFamily.where(parent_id: commercial_family.id).each do |pf|
        commercial_market.product_families << pf
      end
      commercial_market.save
    rescue
      puts "Problem rearranging commercial families"
    end

    brand.product_families.find("amp-accessories").update_attributes(hide_from_homepage: true)
    brand.product_families.find("microphones--2").update_attributes(hide_from_homepage: true)

    puts "Done. Don't run this task again unless you're really sure."
    puts "It will probably delete something you need the second time."


  end
end
