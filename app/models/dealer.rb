class Dealer < ApplicationRecord
  attr_accessor :sold_to, :del_flag, :del_block, :order_block # extra fields from import report
  attribute :distance, :float # temporarily holds distance from search origin on where to buy page
  acts_as_mappable
  validates :address, :name, presence: true
  validates :account_number, presence: true, uniqueness: { case_sensitive: false }
  before_validation :format_account_number
  before_validation :geocode_address, on: :create
  before_validation :auto_exclude
  before_update :regeocode
  has_many :dealer_users, dependent: :destroy, inverse_of: :dealer
  has_many :users, through: :dealer_users
  has_many :brand_dealers, dependent: :destroy
  has_many :brands, through: :brand_dealers
  accepts_nested_attributes_for :brand_dealers

  scope :near, -> (brand, origin, within_miles) {
    brand.dealers.select{|d| d.distance_from(origin) <= within_miles}
  }

  scope :rental_products_and_product_families, -> (brand, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", brand.id, dealer.id).first
    results = []
    if brand_dealer.present?
      results = rental_products(brand, dealer).to_ary
      begin
        if results.pluck(:cached_slug).grep(/jbl-eon7/).any?
          results.delete_if {|item| item.cached_slug["jbl-eon7"].present? }
          results << ProductFamily.find_by_cached_slug("eon700-series")
        end
        if results.pluck(:cached_slug).grep(/prx9/).any?
          results.delete_if {|item| item.cached_slug.include?("prx9") }
          results << ProductFamily.find_by_cached_slug("prx900-series")
        end
        if results.pluck(:cached_slug).grep(/srx9/).any?
          results.delete_if {|item| item.cached_slug.include?("srx9") }
          results << ProductFamily.find_by_cached_slug("srx900-series")
        end
      rescue => e
        error_message = "Error in Dealer.rental_products_and_product_families. BrandDealer #{brand_dealer.id} #{e.message}"
        puts error_message
        #logger.debug error_message
      end  #  begin
    end  #  if brand_dealer.present?
    results
  }  #  scope :rental_products_and_product_families, -> (brand, dealer) {

  scope :rental_products, -> (brand, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", brand.id, dealer.id).first
    if brand_dealer.present?
      begin
        Rails.cache.fetch("rental_products_#{brand.id}_#{dealer.id}", expires_in: 6.hours) do
          Product.joins(:brand_dealer_rental_products).where("brand_dealer_rental_products.brand_dealer_id = ?", brand_dealer).order(:position)
        end
      rescue => e
        error_message = "Error in Dealer.rental_products. BrandDealer #{brand_dealer.id} #{e.message}"
        puts error_message
        #logger.debug error_message
        []
      end  #  begin
    end  #  if brand_dealer.present?
  }  #  scope :rental_products, -> (brand, dealer) {

  scope :available_rental_products, -> (brand, dealer) {
    existing_rental_products = rental_products(brand, dealer)
    if existing_rental_products.present?
      brand.products.where.not(id: existing_rental_products.pluck(:id))
    else
      brand.products
    end
  }

  scope :rental_product_associations, -> (brand, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", brand.id, dealer.id).first
    associations_to_return = []
    if brand_dealer.present?
      associations_to_return = brand_dealer.brand_dealer_rental_products
    end
    associations_to_return
  }

  scope :rental_products_tour_only, -> (brand, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", brand.id, dealer.id).first
    results = []
    if brand_dealer.present?
      results = rental_products(brand, dealer).to_ary
      results.delete_if {|item| !item.name.start_with? "VT"}
    end
    results
  }

  scope :rental_products_eon700_only, -> (brand, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", brand.id, dealer.id).first
    results = []
    if brand_dealer.present?
      results = rental_products(brand, dealer).to_ary
      results.delete_if {|item| !item.cached_slug["jbl-eon7"].present? }
    end
    results
  }

  scope :rental_products_prx_one_only, -> (brand, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", brand.id, dealer.id).first
    results = []
    if brand_dealer.present?
      results = rental_products(brand, dealer).to_ary
      results.delete_if {|item| !item.cached_slug["prx-one"].present? }
    end
    results
  }

  scope :rental_products_eon_one_mk2_only, -> (brand, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", brand.id, dealer.id).first
    results = []
    if brand_dealer.present?
      results = rental_products(brand, dealer).to_ary
      results.delete_if {|item| !item.cached_slug["jbl-eon-one-mk2"].present? }
    end
    results
  }

  def parent
    if !!(self.account_number.match(/^(\d*)\-+\d*$/))
      if p = Dealer.where(account_number: $1).first
        p
      else
        self
      end
    else
      self
    end
  end

  # ship-tos
  def children
    if !!(self.account_number.match(/^(\d*)$/))
      Dealer.where("account_number LIKE ?", "%#{$1}-%")
    end
  end

  # Add this dealer and its children (if any) to the given brand
  def add_to_brand!(brand)
    bd = BrandDealer.where(dealer_id: self.id, brand_id: brand.id).first_or_initialize
    bd.save

    if self.children.present?
      self.children.each do |child|
        bd = BrandDealer.where(dealer_id: child.id, brand_id: brand.id).first_or_initialize
        bd.save
      end
    end
  end

  def format_account_number
    self.account_number = self.account_number.to_s.gsub(/^0*/, '') # ("%010d" % self.account_number.to_i).to_s
  end

  # Format the address, city, state, zip into a single string for geocoding
  def address_string
    "#{address}, #{city}, #{state} #{zip} #{country}".gsub(/<br>/i, ' ').gsub(/,\s?,/, ',').gsub(/\r\n|\r|\n|\t/, ' ').gsub(/\&amp\;/, '&').gsub(/\s{2,}/, ' ')
  end

  def name_and_address
    "#{name} (#{address_string})"
  end

  # Geocode if the address has changed
  def regeocode
    geocode_address if (address_changed? || city_changed? || state_changed?) && !(lat_changed? && lng_changed?)
  end

  def regeocode!
    geocode_address && save(validate: false)
  end

  # Geocode the address and store the lat/lng
  def geocode_address
    if lat.blank? || lng.blank?
      geo = Geokit::Geocoders::MultiGeocoder.geocode(self.address_string)
      if geo.success
        self.lat, self.lng = geo.lat, geo.lng
      else
        puts geo.class
        errors.add(:lat, "Could not Geocode address")
        logger.debug "Could not Geocode #{self.address_string}"
      end
    end
  end

  # When creating/updating, flag some to be excluded from site search results.
  # Business rules are coded below.
  #
  def auto_exclude
    self.exclude ||= true if !!(address.to_s.match(/p\.?\s?o\.?\sbox/i)) ||  # PO Boxes
      !!(self.del_flag.to_s.match(/\W/)) ||
      !!(self.del_block.to_s.match(/\W/)) ||
      !!(self.order_block.to_s.match(/\W/)) ||
      #account_number.split(/\-/).first.to_i > 700000 || # distributors, internal accounts
      marked_for_deletion? || # those which have deleted-type words in the name
      self.class.excluded_accounts.include?(self.account_number) # those which are flagged in the yaml file
  end

  # Is this Dealer excluded?
  def exclude?
    self.exclude == true || self.class.excluded_accounts.include?(self.account_number)
  end

  # Exclude these account numbers
  def self.excluded_accounts
    @excluded_accounts ||= YAML::load_file(Rails.root.join("db", "excluded_dealers.yml"))
    #%w{100857 103036 103639 103641 101656}
  end

  def marked_for_deletion?
    !!(self.name_and_address.to_s.match(/dl reps|vision 2|deleted|don\'t|deletion|do not|closed|collection|credit|out of business|bankruptcy|amazon\.com|distrib|avad|inactive|freight|mars music|unknown|dig\-|hmg|factory\-|promo/i))
  end

  def website_link
    if self.website.present?
      self.website.match(/^http/) ? self.website.downcase : "http://#{self.website.downcase}"
    end
  end

  def self.simple_report(brand, options={}, dealer_list=[])
    options = { rental: false, resell: false, title: "Dealers", format: 'xls' }.merge
    if dealer_list.present?
      dealers = dealer_list
    else
      dealers = brand.dealers
      if options[:rental]
        dealers = dealers.where(rental: true)
      end
      if options[:resell]
        dealers = dealers.where(resell: true)
      end
    end  #  if dealer_list.present?

    if options[:format] == 'xls'
      xls_report = StringIO.new
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet

      column_header_format = Spreadsheet::Format.new(
        weight: :bold
      )

      sheet.row(0).default_format = column_header_format
      sheet.row(0).push 'Region', 'Country', 'Dealer', 'Contact', 'Address', 'City', 'State', 'Postal Code', 'Phone', 'Email', 'Website', 'Rental Products'
      sheet.column(0).width = 20 # Region
      sheet.column(1).width = 20 # Country
      sheet.column(2).width = 30 # Dealer
      sheet.column(3).width = 20 # Contact
      sheet.column(4).width = 40 # Address
      sheet.column(5).width = 20 # City
      sheet.column(6).width = 20 # State
      sheet.column(7).width = 20 # Postal Code
      sheet.column(8).width = 20 # Phone
      sheet.column(9).width = 20 # Email
      sheet.column(10).width = 20 # Website
      sheet.column(11).width = 50 # Rental Products

      row = 1

      dealers.each do |dealer|
        addr = dealer.address.gsub("<br />", ", ").gsub("<br>",", ").gsub("<br/>",", ") if dealer.address.present?
            sheet[row, 0] = dealer.region
            sheet[row, 1] = dealer.country
            sheet[row, 2] = dealer.name
            sheet[row, 3] = dealer.name2  #  contact note
            sheet[row, 4] = addr
            sheet[row, 5] = dealer.city
            sheet[row, 6] = dealer.state
            sheet[row, 7] = dealer.zip
            sheet[row, 8] = dealer.telephone
            sheet[row, 9] = dealer.email
            sheet[row, 10] = dealer.website
            sheet[row, 11] = dealer.rental_product_names(brand)
        row += 1
      end  #  dealers.each do |dealer|

      book.write(xls_report)
      xls_report.string

    end  #  if options[:format] == 'xls'

  end  #  def self.simple_report(brand, options={}, dealer_list=[])

  def self.simple_report_for_admin(brand, options={}, dealer_list=[], product_slugs=[], discontinued_product_slugs=[])
    options = { rental: false, resell: false, title: "Dealers", format: 'xls' }.merge
    if dealer_list.present?
      dealers = dealer_list
    else
      dealers = brand.dealers
      if options[:rental]
        dealers = dealers.where(rental: true)
      end
      if options[:resell]
        dealers = dealers.where(resell: true)
      end
    end  #  if dealer_list.present?

    if options[:format] == 'xls'
      xls_report = StringIO.new
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet

      column_header_format = Spreadsheet::Format.new(
        weight: :bold
      )

      sheet.row(0).default_format = column_header_format
      standard_headers = ['Region*', 'Country*', 'Dealer_ID', 'Dealer Name*', 'Address*', 'Address 2', 'Address 3', 'Town/City*', 'State/Province', 'Postalcode/ZIP*', 'Phone', 'Email', 'Website']
      if product_slugs.present?
        sheet.row(0).concat (standard_headers + product_slugs)
      else
        sheet.row(0).concat (standard_headers + ['Rental Products'])
      end
      sheet.column(0).width = 20 # Region
      sheet.column(1).width = 20 # Country
      sheet.column(2).width = 10 # Dealer ID (in website)
      sheet.column(3).width = 30 # Dealer
      sheet.column(4).width = 40 # Address
      sheet.column(5).width = 40 # Address 2
      sheet.column(6).width = 40 # Address 3
      sheet.column(7).width = 20 # City
      sheet.column(8).width = 20 # State
      sheet.column(9).width = 20 # Postal Code
      sheet.column(10).width = 20 # Phone
      sheet.column(11).width = 20 # Email
      sheet.column(12).width = 20 # Website
      if product_slugs.present?
        product_header_format = Spreadsheet::Format.new(:align => 'center')
        product_discontinued_header_format = Spreadsheet::Format.new(:align => 'center', color: :red)
        product_value_format = Spreadsheet::Format.new(:align => 'center')

        start_col_for_products = 13
        end_col_for_products = product_slugs.count+13

        (start_col_for_products..end_col_for_products).each do |column_index|
          product = product_slugs[column_index-13]
          # for the header row
          if product.present? && discontinued_product_slugs.include?(product)
            sheet.row(0).set_format(column_index, product_discontinued_header_format)
          else
            sheet.row(0).set_format(column_index, product_header_format)
          end

          sheet.column(column_index).width = 16
          # for all values in column
          sheet.column(column_index).default_format = product_value_format
        end
      else
        sheet.column(13).width = 50 # Rental Products
      end  #  if product_slugs.present?

      row = 1

      dealers.each do |dealer|
        addr = dealer.address.gsub("<br />", "---addr-break---").gsub("<br>","---addr-break---").gsub("<br/>","---addr-break---") if dealer.address.present?
        addr1 = addr.split("---addr-break---")[0] if addr.present?
        addr2 = addr.split("---addr-break---")[1] if addr.present?
        addr3 = addr.split("---addr-break---")[2] if addr.present?
            sheet[row, 0] = dealer.region
            sheet[row, 1] = dealer.country
            sheet[row, 2] = dealer.id
            sheet[row, 3] = dealer.name
            sheet[row, 4] = addr1
            sheet[row, 5] = addr2
            sheet[row, 6] = addr3
            sheet[row, 7] = dealer.city
            sheet[row, 8] = dealer.state
            sheet[row, 9] = dealer.zip
            sheet[row, 10] = dealer.telephone
            sheet[row, 11] = dealer.email
            sheet[row, 12] = dealer.website
            if product_slugs.present?
              (start_col_for_products..end_col_for_products).each do |column_index|
                product_column_slug = product_slugs[column_index-13]
                begin
                  if dealer.rental_product_slugs(brand).split(",").include?(product_column_slug)
                    sheet[row, column_index] = "X"
                  end
                rescue => e
                  # binding.pry
                end

              end  #  (start_col_for_products..end_col_for_products).each do |column_index|
            end  #  if product_slugs.present?

        row += 1
      end  #  dealers.each do |dealer|

      book.write(xls_report)
      xls_report.string

    end  #  if options[:format] == 'xls'

  end  #  def self.simple_report_for_admin(brand, options={}, dealer_list=[])

  def self.simple_report_for_admin_by_type(brand, options={}, dealer_list=[], product_slugs=[])
    options = { title: "Dealers", format: 'xls' }.merge
    dealers = dealer_list

    if options[:format] == 'xls'
      xls_report = StringIO.new
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet

      column_header_format = Spreadsheet::Format.new(
        weight: :bold
      )

      sheet.row(0).default_format = column_header_format
      standard_headers = ['Region*', 'Country*', 'Dealer_ID', 'Dealer Name*', 'Address*', 'Address 2', 'Address 3', 'Town/City*', 'State/Province', 'Postalcode/ZIP*', 'Phone', 'Email', 'Website', 'Is Install Company?', 'Is Rental Company?', 'Is Resale Company?', 'Is Service Company?']
      sheet.row(0).concat (standard_headers)

      sheet.column(0).width = 20 # Region
      sheet.column(1).width = 20 # Country
      sheet.column(2).width = 10 # Dealer ID (in website)
      sheet.column(3).width = 30 # Dealer
      sheet.column(4).width = 40 # Address
      sheet.column(5).width = 40 # Address 2
      sheet.column(6).width = 40 # Address 3
      sheet.column(7).width = 20 # City
      sheet.column(8).width = 20 # State
      sheet.column(9).width = 20 # Postal Code
      sheet.column(10).width = 20 # Phone
      sheet.column(11).width = 20 # Email
      sheet.column(12).width = 20 # Website
      sheet.column(13).width = 20 # Install
      sheet.column(14).width = 20 # Rental
      sheet.column(15).width = 20 # Resale
      sheet.column(16).width = 20 # Service


      row = 1

      dealers.each do |dealer|
        addr = dealer.address.gsub("<br />", "---addr-break---").gsub("<br>","---addr-break---").gsub("<br/>","---addr-break---") if dealer.address.present?
        addr1 = addr.split("---addr-break---")[0] if addr.present?
        addr2 = addr.split("---addr-break---")[1] if addr.present?
        addr3 = addr.split("---addr-break---")[2] if addr.present?
            sheet[row, 0] = dealer.region
            sheet[row, 1] = dealer.country
            sheet[row, 2] = dealer.id
            sheet[row, 3] = dealer.name
            sheet[row, 4] = addr1
            sheet[row, 5] = addr2
            sheet[row, 6] = addr3
            sheet[row, 7] = dealer.city
            sheet[row, 8] = dealer.state
            sheet[row, 9] = dealer.zip
            sheet[row, 10] = dealer.telephone
            sheet[row, 11] = dealer.email
            sheet[row, 12] = dealer.website
            sheet[row, 13] = dealer.installation
            sheet[row, 14] = dealer.rental
            sheet[row, 15] = dealer.resale
            sheet[row, 16] = dealer.service

        row += 1
      end  #  dealers.each do |dealer|

      book.write(xls_report)
      xls_report.string

    end  #  if options[:format] == 'xls'

  end  #  def self.simple_report_for_admin_by_type(brand, options={}, dealer_list=[])

  def self.report(brand, options={}, dealer_list=[])
    options = { rental: false, resell: false, title: "Dealers", format: 'xls' }.merge options
    if dealer_list.present?
      dealers = dealer_list
    else
      dealers = brand.dealers
      if options[:rental]
        dealers = dealers.where(rental: true)
      end
      if options[:resell]
        dealers = dealers.where(resell: true)
      end
    end


    if options[:format] == 'xls'
      xls_report = StringIO.new
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet

      sheet.column(0).width = 40
      sheet.column(1).width = 30
      sheet.column(2).width = 10
      sheet.column(3).width = 30
      sheet.column(4).width = 10
      sheet.column(5).width = 30
      sheet.column(6).width = 10
      sheet.column(7).width = 40

      title_format = Spreadsheet::Format.new(
        color: :white,
        size: 20,
        pattern_bg_color: :black,
        pattern: 1
      )
      subtitle_format = Spreadsheet::Format.new(
        color: :white,
        size: 12,
        pattern_bg_color: :black,
        pattern: 1
      )
      region_format = Spreadsheet::Format.new(
        color: :white,
        size: 10,
        align: :center,
        pattern_bg_color: :black,
        pattern: 1
      )
      country_format = Spreadsheet::Format.new(
        color: :white,
        size: 10,
        align: :center,
        pattern_fg_color: :grey,
        pattern: 1
      )
      dealer_name_format = Spreadsheet::Format.new(
        weight: :bold,
        top: :thin
      )
      line_above_format = Spreadsheet::Format.new(
        top: :thin
      )

      sheet.row(0).default_format = title_format
      sheet[0,0] = options[:title]
      sheet.merge_cells(0, 0, 0, 7)  #  sheet.merge_cells(start_row, start_col, end_row, end_col)
      sheet.row(1).default_format = subtitle_format
      sheet[1,0] = "current as of #{ I18n.l(Date.today, format: :short) }"
      sheet.merge_cells(1, 0, 1, 7)  #  sheet.merge_cells(start_row, start_col, end_row, end_col)

      row = 2

      dealers.index_by(&:region).each do |region|
        sheet.row(row).default_format = region_format
        sheet[row, 0] = region[1].region.blank? ? "(empty region)" : region[1].region
        sheet.merge_cells(row, 0, row, 7)
        row += 1
        dealers.select{|item| item.region == region[1].region}.index_by(&:country).each do |country|
          sheet.row(row).default_format = country_format
          sheet[row, 0] = country[1].country.blank? ? "(empty country)" : country[1].country
          sheet.merge_cells(row, 0, row, 7)
          row += 1
          dealers.select{|item| item.region == region[1].region && item.country == country[1].country}.sort_by(&:name).each do |dealer|
            addr = dealer.address.split(/\<br\/?\>/i) if dealer.address.present?
            sheet.row(row).default_format = line_above_format
            sheet.row(row).set_format(0, dealer_name_format)
            (0..6).each do |c|
              sheet.row(row).format(c).left = :thin
            end
            sheet[row, 0] = dealer.name
            sheet[row, 1] = dealer.name2
            sheet[row, 2] = "Phone:"
            sheet[row, 3] = dealer.telephone
            sheet[row, 4] = "Email:"
            sheet[row, 5] = dealer.email
            sheet[row, 6] = "Models:"
            sheet[row, 7] = dealer.rental_product_names(brand)
            row += 1
            (0..6).each do |c|
              sheet.row(row).format(c).left = :thin
            end
            sheet[row, 0] = addr.pop if addr.present?
            row += 1
            (0..6).each do |c|
              sheet.row(row).format(c).left = :thin
            end
            sheet[row, 0] = addr.join("\n") if addr.present?
            sheet[row, 2] = "Fax:"
            sheet[row, 3] = dealer.fax if dealer.fax.to_s.match(/\d/)
            sheet[row, 4] = "Website:"
            sheet[row, 5] = dealer.website
            row += 1
            (0..6).each do |c|
              sheet.row(row).format(c).left = :thin
            end
            sheet[row, 0] = "#{dealer.city} #{dealer.state} #{dealer.zip}"
            row += 1
            (0..6).each do |c|
              sheet.row(row).format(c).left = :thin
            end
            sheet[row, 0] = dealer.country
            row += 1
            (0..6).each do |c|
              sheet.row(row).format(c).left = :thin
            end
          end
        end
      end

      book.write(xls_report)
      xls_report.string
    else
      dealers # no other formats supported yet
    end
  end  #  def self.report(brand, options={})

  def rental_product_names(brand)
    Rails.cache.fetch("rental_product_names_#{brand.id}_#{self.id}", expires_in: 6.hours) do
      results = rental_products(brand).to_ary

      if results.pluck(:cached_slug).grep(/jbl-eon7/).any?
        results.delete_if {|item| item.cached_slug["jbl-eon7"].present? }
        results << ProductFamily.find_by_cached_slug("eon700-series")
      end
      if results.pluck(:cached_slug).grep(/prx9/).any?
        results.delete_if {|item| item.cached_slug.include?("prx9") }
        results << ProductFamily.find_by_cached_slug("prx900-series")
      end
      if results.pluck(:cached_slug).grep(/srx9/).any?
        results.delete_if {|item| item.cached_slug.include?("srx9") }
        results << ProductFamily.find_by_cached_slug("srx900-series")
      end
      results.pluck(:name).join(', ')
    end  #  Rails.cache.fetch("rental_product_names_#{brand.id}_#{self.id}", expires_in: 6.hours) do
  end  #  def rental_product_names(brand)

  def rental_product_slugs(brand)
    Rails.cache.fetch("rental_product_slugs_#{brand.id}_#{self.id}", expires_in: 6.hours) do
      # calls instance method rental_products(brand) which calls scope (class) method rental_products(brand,dealer)
      results = rental_products(brand).to_ary

      if results.pluck(:cached_slug).grep(/jbl-eon7/).any?
        results.delete_if {|item| item.cached_slug["jbl-eon7"].present? }
        results << ProductFamily.find_by_cached_slug("eon700-series")
      end
      if results.pluck(:cached_slug).grep(/prx9/).any?
        results.delete_if {|item| item.cached_slug.include?("prx9") }
        results << ProductFamily.find_by_cached_slug("prx900-series")
      end
      if results.pluck(:cached_slug).grep(/srx9/).any?
        results.delete_if {|item| item.cached_slug.include?("srx9") }
        results << ProductFamily.find_by_cached_slug("srx900-series")
      end
      results.pluck(:cached_slug).join(',')
    end  #  Rails.cache.fetch("rental_product_slugs_#{brand.id}_#{self.id}", expires_in: 6.hours) do
  end  #  def rental_product_slugs(brand)

  def has_rental_products_for(brand, cached_slug)  #  this currently only applies to jbl pro
    results = false
    if cached_slug == "jbl-eon7" || cached_slug == "prx9" || cached_slug == "srx9" || cached_slug == "vt"
      results = rental_products(brand).pluck(:cached_slug).map{|item| item.downcase}.select{|item| item.start_with? "#{cached_slug}"}.present?
    else
      results = rental_products(brand).pluck(:cached_slug).map{|item| item.downcase}.include? "#{cached_slug}"
    end
    results
  end  #  def has_rental_products_for(brand, cached_slug)

  def rental_products(brand)
    # calls scope method rental_products, returns a set of activerecord relations
    self.class.rental_products(brand,self)
  end
end  #  class Dealer < ApplicationRecord
