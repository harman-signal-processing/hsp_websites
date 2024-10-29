class WarrantyRegistration < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :brand
  belongs_to :product
  validates :first_name, :last_name, :country, presence: true, length: 1..127, format: {
    without: /[\\\/\$\%\^\&\*]|http/i, message: "invalid characters found"
  }
  validate :first_and_last_name_must_be_different
  validate :company_not_google
  validates :serial_number, :purchased_on, presence: true, length: 1..127
  validates :email, presence: true, email: true, length: 1..127
  validates :company, presence: true, if: :require_company?
  after_create :execute_promotion, :sync_with_service_department
  attr_reader :purchase_city

  class << self
    # The fields to be exported to the file which is later imported into SAP. This list
    # of attributes is in the order SAP expects to see them.
    def export_fields
      %w{title first_name last_name middle_initial company jobtitle country
        email subscribe brand_name model serial_number registered_on purchased_on
        purchased_from purchase_city purchase_country purchase_price comments}
    end
  end

  # Sends a confirmation back to the customer
  def send_email_confirmation
    SiteMailer.delay.confirm_product_registration(self)
  end

  # This could be used to automatically send registrants promotion materials
  # after they've registered a product. (ie, Jamplay.com discount code)
  def execute_promotion
    begin
      self.product.promotions.where(send_post_registration_message: true).find_each do |promo|
        if self.created_at.to_date >= promo.start_on.to_date && self.created_at.to_date <= promo.end_on.to_date
          SiteMailer.delay.promo_post_registration(self, promo)
        end
      end
    rescue
      logger.debug "problem executing a promotion"
    end
  end

  # Only Studer wants the company required
  def require_company?
    !!(self.brand && self.brand.name.to_s.match(/studer/i))
  end

  def first_and_last_name_must_be_different
    if first_name == last_name
      errors.add(:base, "Something is not right about the values provided.")
    end
  end

  def company_not_google
    if company == "google"
      errors.add(:base, "Something is not right about the values provided.")
    end
  end

  # String output matching the legacy format which SAP uses to import these records
  def to_export
    self.class.export_fields.map{|f| eval("self.#{f}")}.join("|")
  end

  # brand name
  def brand_name
    begin
      self.brand.name.upcase
    rescue
      ""
    end
  end

  # product name
  def product_name
    begin
      self.product.name
    rescue
      self.product_id
    end
  end

  # model
  def model
    begin
      self.product.sap_sku.upcase
    rescue
      ""
    end
  end

  # Sync registration with hpro
  def sync_with_service_department
    if needs_sync?
      begin
        start_sync
        update(synced_on: Date.today)
      rescue
        logger.debug "Something went wrong sending registration: #{self.inspect}"
      end
    end
  end
  handle_asynchronously :sync_with_service_department

  private

  def needs_sync?
    synced_on.blank? #&& (country.to_s.match(/^US|USA|United States/))
  end

  # Fill out remote form for warranty.harmanpro.com
  def start_sync
    agent = Mechanize.new
    page = agent.get(ENV['warranty_sync_url'])
    form = page.form_with(name: "form1")
    form.txtMaterialNo   = product_name
    form.txtSerialNo     = serial_number
    form.txtPurchaseDate = I18n.l(purchased_on, format: :mmddyyyy)
    form.txtFirstName    = first_name
    form.txtLastName     = last_name
    form.txtAddress      = ""
    form.txtCity         = ""
    form.txtPostalCode   = ""
    form.txtEmail        = email

    begin
      if country.to_s.match(/^US$/i) || country.to_s.match(/United States/i)
        country = "USA"
      end
      form.field_with(name: "ddlCountry").option_with(text: country).click
    rescue
      # Couldn't select country
    end

    button = form.button_with(name: "btnSubmit")
    agent.submit(form, button)
  end

end
