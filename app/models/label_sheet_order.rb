class LabelSheetOrder < ActiveRecord::Base
  require 'securerandom'

  belongs_to :user
  # attr_accessible :label_sheet_ids, :name, :email, :address, :city, :state, :postal_code, :country, :subscribe
  attr_accessor :label_sheet_ids

  validates :name, :email, :address, :city, :state, :postal_code, :country, presence: true
  validate :has_label_sheets, on: :create

  serialize :label_sheets, Array
  before_save :encode_label_sheet_ids, :generate_secret_code, :notify_customer
  after_create :send_the_order

  def encode_label_sheet_ids
  	if self.label_sheet_ids.present?
    	self.label_sheets = (self.label_sheet_ids.is_a?(String)) ? self.label_sheet_ids.split(/\,\s?/) : self.label_sheet_ids
    end
  end

  def expanded_label_sheets
    s = []
    self.label_sheets.each do |i| 
      begin
        s << LabelSheet.find(i)
      rescue
        # Sheet was probably deleted
      end
    end
    s
  end

  def generate_secret_code
  	self.secret_code ||= SecureRandom.urlsafe_base64(20)
  end

  def notify_customer
    if mailed_on_changed? && mailed_on_was == nil && mailed_on.present?
      SiteMailer.delay.label_sheet_order_shipped(self) unless created_at < Time.zone.now.advance(weeks: -6)
    end
  end

  def verify_code(challenge)
  	!!(self.secret_code == challenge)
  end

  def has_label_sheets
    if self.label_sheet_ids.blank?
      errors[:base] << "You must select at least one label sheet"
    end
  end

  def send_the_order
    SiteMailer.delay.label_sheet_order(self)
  end
end
