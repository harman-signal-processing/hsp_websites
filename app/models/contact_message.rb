class ContactMessage < ActiveRecord::Base
  before_validation :set_defaults
  validates :name, :subject, :message_type, presence: true
  validates :email, presence: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :message, presence: true, if: :support?
  validates :product, presence: true, if: :require_product?
  validates :shipping_country, presence: true, if: :require_country?
  validates :phone,
    :shipping_address,
    :shipping_city,
    :shipping_state,
    :shipping_zip,
    :product_sku,
    :product_serial_number,
    :purchased_on, presence: true, if: :rma_request?
  validates :warranty, inclusion: {in: [true, false]}, if: :rma_request?
  attr_accessor :require_country

  def set_defaults
    self.message_type ||= "support" #others: rma_request, part_request
    self.subject ||= "Parts Request" if self.part_request?
    self.subject ||= "RMA Request" if self.rma_request?
    self.email.to_s.gsub!(/\s*$/, '')
  end

  # Used to only require product some of the time, now require
  # it all the time (per Trevor's request)
  #
  def require_product?
    # !!(self.part_request? || self.rma_request?)
    true
  end

  def require_country?
    !!(self.require_country)
  end

  def support?
    !!(self.message_type.match(/support/))
  end

  def part_request?
    !!(self.message_type.match(/part_request/))
  end

  def rma_request?
    !!(self.message_type.match(/rma_request/))
  end

  def self.subjects(options={})
    s = []
    if options[:brand]
      q = SupportSubject.where(brand_id: options[:brand].id)
      if options[:locale]
        q = q.where(locale: [options[:locale], options[:locale].gsub(/\-.*$/, '')])
      else
        q = q.where(locale: [nil, I18n.default_locale])
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

end
