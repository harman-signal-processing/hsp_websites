class ContactMessage < ApplicationRecord
  before_validation :set_defaults
  belongs_to :brand

  validates :name, :subject, :message_type, presence: true, length: 1..128
  validates :email, presence: true, length: 1..128, email: true
  validates :message, presence: true, if: :support?
  validates :product, presence: true, length: 1..128, if: :require_product?
  validates :shipping_country, presence: true, length: 1..128, if: :require_country?
  validates :phone,
    :shipping_address,
    :shipping_city,
    :shipping_state,
    :shipping_zip,
#    :product_sku,
    :product_serial_number,
    :purchased_on, presence: true, length: 1..128, if: :require_purchase_date?
  validates :shipping_address,
    :shipping_city,
    :shipping_state,
    :shipping_zip,
    :shipping_country, presence: true, length: 1..128, if: :catalog_request?
  validates :warranty, inclusion: {in: [true, false]}, if: :rma_request?

  validates :shipping_address,
    :shipping_city,
    :shipping_state,
    :shipping_zip,
    :shipping_country, presence: true, length: 1..128, if: :require_shipping_address?

  attr_accessor :require_country, :email_to, :products, :security_request_type, :other, :additional_info

  def set_defaults
    self.message_type ||= "support" #others: rma_request, part_request
    self.subject ||= "Parts Request" if self.part_request?
    self.subject ||= "RMA Request" if self.rma_request?
    # Amx needs to split rma into repair or credit, all other brands use one rma type
    self.subject ||= "RMA Repair Request" if self.rma_repair_request?
    self.subject ||= "RMA Credit Request" if self.rma_credit_request?
    self.subject ||= "HARMAN Professional Catalog request" if self.catalog_request?
    self.email.to_s.gsub!(/\s*$/, '')
    self.shipping_country ||= "United States"
  end  #  def set_defaults

  # Used to only require product some of the time, now require
  # it all the time (per Trevor's request)
  #
  def require_product?
    !!!catalog_request?
  end

  def require_purchase_date?
    rma_request? && !self.brand.name.to_s.match(/crown/i)
  end

  def require_country?
    !!(self.require_country)
  end

  def support?
    !!(self.message_type.to_s.match(/support/))
  end

  def part_request?
    !!(self.message_type.to_s.match(/part_request/))
  end

  def rma_request?
    !!(self.message_type.to_s.match(/rma_request/))
  end

  def rma_repair_request?
    !!(self.message_type.to_s.match(/rma_repair_request/))
  end
  
  def rma_credit_request?
    !!(self.message_type.to_s.match(/rma_credit_request/))
  end

  def require_shipping_address?
    self.rma_request? || self.rma_repair_request? || self.rma_credit_request?
  end

  def catalog_request?
    !!(self.message_type.to_s.match(/catalog_request/))
  end

  def self.subjects(options={})
    s = []
    if options[:brand]
      q = SupportSubject.where(brand_id: options[:brand].id)
      if options[:locale]
        q = q.where(locale: [options[:locale], options[:locale].gsub(/\-.*$/, '')])
      else
        q = q.where(locale: [nil, I18n.default_locale, 'en-US', ''])
      end
      q.order(:position).each do |subj|
        s << [subj.name]
      end
    end

    s.length > 0 ? s : default_subjects
  end

  def self.default_subjects
    [
      [I18n.t('subjects.product_question')],
      [I18n.t('subjects.technical_support')],
      [I18n.t('subjects.manual_request')],
      [I18n.t('subjects.product_repair')],
      [I18n.t('subjects.product_parts')],
      [I18n.t('subjects.general_questions')],
      ["-------------------------", ""],
      [I18n.t('subjects.order_status')],
      [I18n.t('subjects.dealer_questions')],
      ["-------------------------", ""],
      [I18n.t('subjects.web_comments')]
    ]
  end

  def recipients
    @recipients ||= get_recipients
  end

  private

  def get_recipients
    # Route by message type
    if catalog_request?
      return ["service@sullivangroupusa.com"]
    elsif rma_request?
      return [brand.rma_email]
    elsif rma_repair_request?
      return [brand.rma_repair_email]
    elsif rma_credit_request?
      return [brand.rma_credit_email]
    elsif part_request?
      return [brand.parts_email]
    end

    recipients = [brand.support_email]
    recipients << self.email_to if self.email_to.present?

    # Fix "United States of America" which should be "United States"
    if self.shipping_country.present? && self.shipping_country == "United States of America"
      self.shipping_country = "United States"
    end

    # Route by country
    if brand.send_contact_form_to_distributors? &&
        self.shipping_country.present? &&
        distributors.size == 1
      recipients = distributors.pluck(:email)

    # Route by intl sales region
    elsif brand.send_contact_form_to_regional_support? &&
        self.shipping_country.present? &&
        regions.exists?
      recipients = regions.pluck(:support_email)

    # Route by subject
    elsif subj = SupportSubject.where(brand_id: brand_id, name: subject).first
      recipients << subj.recipient if subj.recipient.present?
    end

    if brand.try(:support_cc_list)
      recipients += brand.support_cc_list.split(/[\,\;\s]\s?/)
    end

    recipients.uniq
  end  #  def get_recipients

  def distributors
    @distributors ||= brand.distributors.where(country: self.shipping_country).where("email IS NOT NULL")
  end

  def regions
    @regions ||= brand.sales_regions.
      includes(:sales_region_countries).
      where("support_email IS NOT NULL").
      where(sales_region_countries: { name: self.shipping_country})
  end  #  def regions
end  #  class ContactMessage < ApplicationRecord
