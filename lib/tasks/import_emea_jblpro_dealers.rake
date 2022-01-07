require "csv"

namespace :import do

  # t = Time.now.localtime(Time.now.in_time_zone('America/Chicago').utc_offset)
  # filename = "jblpro_dealer_update.#{t.month}.#{t.day}.#{t.year}_#{t.strftime("%I.%M.%S_%p")}.log"
  # log = ActiveSupport::Logger.new("log/#{filename}")

  desc "Import EMEA JBLPro dealers"
  task emea_jblpro_dealers: :environment do

    # !!!!!!!!!!!!!!!!!!
    # If true we really make updates to the database. If false we do not make updates to the database, we only do reads and output statuses.
    really_run = true
    # !!!!!!!!!!!!!!!!!!

    t = Time.now.localtime(Time.now.in_time_zone('America/Chicago').utc_offset)
    filename = "jblpro_dealer_update.#{t.month}.#{t.day}.#{t.year}_#{t.strftime("%I.%M.%S_%p")}.log"
    log = ActiveSupport::Logger.new("log/#{filename}")


    jblpro = Brand.find("jbl-professional")
    dealers_file = Rails.root.join("db", "Updated-Retail-Tour-EMEA-Where-to-buy-list-v1.4-utf-8-cleaned.csv")
    count = 0
    country_list = []

    start_time = Time.now
    total_dealer_count_at_beginning = Dealer.all.count
    jblpro_dealer_count_at_beginning = jblpro.dealers.length
    new_dealer_count = 0
    updated_dealer_count = 0

    write_message(log, "")
    write_message(log, "Running in #{ENV["RAILS_ENV"]}")
    write_message(log, "Making database updates: #{really_run}")
    write_message(log, "") # line break

    # delete_previous_records_from_this_import

    CSV.open(dealers_file, encoding:'utf-8', headers: true).each do |row|
      # note add an ID column to the excel file before exporting as csv, the id column is used to provide dealer ids back to the data providers so they can be used for future updates
      name = "#{row[1]}"
      break if (name.nil?)
      address1 = "#{row[2]}"
      address2 = "#{row[3]}"
      address3 = "#{row[4]}"
      address_to_use = address1
      address_to_use += "<br />#{address2}" if address2.present?
      address_to_use += "<br />#{address3}" if address3.present?
      city = "#{row[5]}"
      zip = "#{row[6]}"
      country = "#{row[7]}"
      # website = "https://#{row[7]}"
      website = "#{row[8]}"
      email = "#{row[9]}"
      telephone = "#{row[10]}"
      count += 1
      account_number_to_use = "jblpro-#{count}"

      begin
        country_list |= [country_name_to_use[country.to_sym]]
      rescue => e
        write_message(log, "Country #{country} not found. Error: #{e.message}",".red")
      end

      address_string = "#{address_to_use}, #{city}, #{zip} #{country}".gsub(/<br \/>/i, ' ').gsub(/,\s?,/, ',').gsub(/\r\n|\r|\n|\t/, ' ').gsub(/\&amp\;/, '&').gsub(/\s{2,}/, ' ')
      origin = Geokit::Geocoders::MultiGeocoder.geocode(address_string)
      origin = Geokit::Geocoders::MultiGeocoder.geocode("#{zip} #{country}") if origin.lat.nil?

      dealer_products = []
      # load product data
      (11..42).each do |i|
        product_slug_index = i-11
        product_slug = product_slugs[product_slug_index]
        on = row[i].nil? ? false : row[i].downcase == "x"
        if on
          if product_slug == "eon700-series"
            dealer_products = dealer_products + 'jbl-eon710,jbl-eon712,jbl-eon715,jbl-eon718s'.split(',')
            dealer_products.delete_if{|item| item == "eon700-series"}
          elsif product_slug == "vtx-f-series"
            dealer_products = dealer_products + 'vtx-f12,vtx-f15,vtx-f35-95,vtx-f18s,vtx-f35-64'.split(',')
            dealer_products.delete_if{|item| item == "vtx-f-series"}
          else
          dealer_products << product_slug
          end
        end  #  if on
      end  #  (10..41).each do |i|


      data_for_new_dealer = { name: name, address: address_to_use, city: city, zip: zip, country: country_name_to_use[country.to_sym], website: website, telephone: telephone, account_number: account_number_to_use, rental: 1, lat: origin.lat, lng: origin.lng}

      existing_dealer = Dealer.where("name = ? and city = ? and country = ?", name, city, country_name_to_use[country.to_sym])
      if existing_dealer.present?
        write_message(log, "")
        write_message(log, "--------Update Existing--------")
        write_message(log, "Name: #{name}, City: #{city}, Country: #{country}",".red")
        write_message(log, "Dealer ID: #{existing_dealer.first.id}")
        write_message(log, "New Address: #{address_to_use}, #{city}, #{zip}, #{country}",".yellow")
        write_message(log, "Old Address: #{existing_dealer.first.address}, #{city}, #{zip}, #{country}",".yellow")
        write_message(log, "")

        update_existing_dealer(log, jblpro, existing_dealer, data_for_new_dealer, dealer_products, really_run)
        updated_dealer_count += 1
      else
        write_message(log, "")
        write_message(log, "--------Create New--------")
        write_message(log, "Name: #{name}, City: #{city}, Country: #{country}", ".green")
        create_new_dealer(log, jblpro, data_for_new_dealer, dealer_products, really_run)
        new_dealer_count += 1
      end  #  if existing_dealer.present

      write_message(log, "  No products for #{data_for_new_dealer[:name]}",".blue.on_red") if dealer_products.count == 0

    end  #  CSV.open(dealers_file, 'r:ISO-8859-1', headers: true).each do |row|

    write_message(log, "")
    write_message(log, "#{jblpro_dealer_count_at_beginning} JBLPro dealer count at beginning")
    write_message(log, "#{new_dealer_count} New JBLPro dealer count")
    write_message(log, "#{updated_dealer_count} Updated (existing) JBLPro dealer count")
    write_message(log, "#{jblpro.dealers.length} JBLPro dealer count at end")
    write_message(log, "#{total_dealer_count_at_beginning} Total dealers at beginning")
    write_message(log, "#{Dealer.all.count} Total dealers after")
    write_message(log, "")

    end_time = Time.now
    duration = ((end_time - start_time) / 1.minute).truncate(2)

    end_time_formatted = "#{end_time.month}/#{end_time.day}/#{end_time.year} #{end_time.strftime("%I:%M:%S %p")}"

    write_message(log, "Task finished at #{end_time_formatted} and lasted #{duration} minutes.")

  end  #  task emea_jblpro_dealers: :environment do

  def create_new_dealer(log, jblpro, dealer_data, product_data, really_run)
    products_to_add = Product.where("cached_slug in (?)", product_data)

      # This is the real thing, we're actually doing this
      if really_run
        d = Dealer.create!(dealer_data)
        write_message(log, "Dealer ID: #{d.id}")

        if d.present?
          unless jblpro.dealers.include?(d)
            jblpro.dealers << d
          end

          brand_dealer = BrandDealer.where(brand_id: jblpro.id, dealer_id: d.id).first
          products_to_add.to_a.each_with_index do |product, position|
            BrandDealerRentalProduct.create(brand_dealer_id: brand_dealer.id, product_id: product.id, position: position)
            write_message(log, "  Added rental product #{product.name}")
          end  #  products_to_add.to_a.each_with_index do |product, position|

        end  #  if d.present?
      end  #  if really_run


      # Were doing a dry run
      if !really_run
        products_to_add.to_a.each_with_index do |product, position|
          write_message(log, "  Added rental product #{product.name}")
        end
      end  #  if !really_run

  end  #  def create_new_dealer(dealer_data, product_data, really_run)

  def update_existing_dealer(log, jblpro, existing_dealer, dealer_data, product_data, really_run)
    existing_dealer.first.city = dealer_data[:name]
    existing_dealer.first.address = dealer_data[:address]
    existing_dealer.first.city = dealer_data[:city]
    existing_dealer.first.zip = dealer_data[:zip]
    existing_dealer.first.country = dealer_data[:country]
    existing_dealer.first.website = dealer_data[:website]
    existing_dealer.first.telephone = dealer_data[:telephone]
    existing_dealer.first.account_number = dealer_data[:acount_number]
    existing_dealer.first.rental = dealer_data[:rental]

    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", jblpro.id, existing_dealer.first.id).first
    products_to_add = Product.where("cached_slug in (?)", product_data)

    # This is the real thing, we're actually doing this
    if really_run
        # save updates
        existing_dealer.first.save

        # remove any existing brand rental product associations
        BrandDealerRentalProduct.where("brand_dealer_id=?",existing_dealer.first.id).delete_all

        # add rental product associations
        products_to_add.to_a.each_with_index do |product, position|
          BrandDealerRentalProduct.create(brand_dealer_id: brand_dealer.id, product_id: product.id, position: position)
          write_message(log, "  Added rental product #{product.name}")
        end  #  products_to_add.to_a.each_with_index do |product, position|

    end  #  if really_run

    # We are just doing a dry run
    if !really_run
      products_to_add.to_a.each_with_index do |product, position|
        write_message(log, "  Added rental product #{product.name}")
      end
    end  #  if !really_run

  end  #  def update_existing_dealer(dealer_data, product_data, really_run)
  
  def country_name_to_use
    {
      "Albania": "Albania",
      "Austria": "Austria",
      "Belgium": "Belgium",
      "Belguim": "Belgium",
      "Bulgaria": "Bulgaria",
      "Czech Republic": "Czech Republic",
      "Denmark": "Denmark",
      "Estonia": "Estonia",
      "Finland": "Finland",
      "FInland": "Finland",
      "France": "France",
      "Germany": "Germany",
      "Greece": "Greece",
      "Hungary": "Hungary",
      "Italy": "Italy",
      "Latvia": "Latvia",
      "Lithuania": "Lithuania",
      "Netherlands": "Netherlands",
      "Norway": "Norway",
      "Polska": "Poland",
      "Poland": "Poland",
      "Portugal": "Portugal",
      "PORTUGAL": "Portugal",
      "Romania": "Romania",
      "Slovakia": "Slovakia",
      "South Africa": "South Africa",
      "Spain": "Spain",
      "SPAIN": "Spain",
      "Sweden": "Sweden",
      "Switzerland": "Switzerland",
      "The Netherlands": "Netherlands",
      "Turkey": "Turkey",
      "UK": "United Kingdom of Great Britain and Northern Ireland",
      "United Kingdom": "United Kingdom of Great Britain and Northern Ireland"
    }
  end

  def product_slugs
    [
      'eon700-series',
      'jbl-eon-one-mk2',
      'prx-one',
      'vtx-a8',
      'vtx-a12',
      'vtx-a12w',
      'vtx-b18',
      'vtx-b28',
      'vtx-f12',
      'vtx-f18s',
      'vtx-f35-95',
      'vtx-f-series',
      'vtx-g28',
      'vtx-m20',
      'vtx-m22',
      'vtx-s25',
      'vtx-s28',
      'vtx-v20',
      'vtx-v25',
      'vt4880',
      'vt4880a',
      'vt4881a',
      'vt4882',
      'vt4882dp-da-vt4882dp',
      'vt4883',
      'vt4886',
      'vt4887a',
      'vt4887adp-da-vt4887adp',
      'vt4888',
      'vt4888dp-da-vt4888dp',
      'vt4889'
    ]
  end  #  def product_slugs

  def delete_previous_records_from_this_import
    Dealer.where("account_number like '%jblpro%'").delete_all
  end

  def write_message(log, message_to_output="", message_decoration="")
    if ENV["RAILS_ENV"] == "production"  # production doesn't have colorful puts
      puts message_to_output
    else
      puts eval(message_to_output.inspect + message_decoration)
    end
    log.info message_to_output
  end  #  def message(message)

end  #  namespace :import do
