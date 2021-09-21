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

  scope :rental_products, -> (website, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", website.brand.id, dealer.id).first
    if brand_dealer.present?
      Product.joins(:brand_dealer_rental_products).where("brand_dealer_rental_products.brand_dealer_id = ?", brand_dealer).order(:position)
    end
  }

  scope :available_rental_products, -> (website, dealer) {
    existing_rental_products = rental_products(website, dealer)
    if existing_rental_products.present?
      website.products.where.not(id: existing_rental_products.pluck(:id))
    else
      website.products
    end
  }

  scope :rental_product_associations, -> (website, dealer) {
    brand_dealer = BrandDealer.where("brand_id=? and dealer_id=?", website.brand.id, dealer.id).first
    associations_to_return = []
    if brand_dealer.present?
      associations_to_return = brand_dealer.brand_dealer_rental_products
    end
    associations_to_return
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

  def self.report(brand, options={})
    options = { rental: false, resell: false, title: "Dealers", format: 'xls' }.merge options
    dealers = brand.dealers
    if options[:rental]
      dealers = dealers.where(rental: true)
    end
    if options[:resell]
      dealers = dealers.where(resell: true)
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
      sheet.merge_cells(0, 0, 0, 7)
      sheet.row(1).default_format = subtitle_format
      sheet[1,0] = "current as of #{ I18n.l(Date.today, format: :short) }"
      sheet.merge_cells(1, 0, 1, 7)

      row = 2

      dealers.group(:region).each do |region|
        sheet.row(row).default_format = region_format
        sheet[row, 0] = region.region.blank? ? "(empty region)" : region.region
        sheet.merge_cells(row, 0, row, 7)
        row += 1
        dealers.where(region: region.region).group(:country).each do |country|
          sheet.row(row).default_format = country_format
          sheet[row, 0] = country.country.blank? ? "(empty country)" : country.country
          sheet.merge_cells(row, 0, row, 7)
          row += 1
          dealers.where(region: region.region, country: country.country).order(:name).each do |dealer|
            addr = dealer.address.split(/\<br\/?\>/i)
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
            # sheet[row, 7] = dealer.products
            sheet[row, 7] = dealer.rental_product_names
            row += 1
            (0..6).each do |c|
              sheet.row(row).format(c).left = :thin
            end
            sheet[row, 0] = addr.pop
            row += 1
            (0..6).each do |c|
              sheet.row(row).format(c).left = :thin
            end
            sheet[row, 0] = addr.join("\n") if addr.length > 0
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
  end

  def rental_product_names
    Product.find(self.brand_dealers.first.brand_dealer_rental_products.pluck(:product_id)).pluck(:name).join(', ')
  end

end
