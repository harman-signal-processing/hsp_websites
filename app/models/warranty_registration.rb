class WarrantyRegistration < ActiveRecord::Base
  belongs_to :brand
  belongs_to :product
  validates_presence_of :first_name, :last_name, :brand_id, :product_id, :email, :country, :serial_number, :purchased_on
  after_create :execute_promotion
  attr_reader :purchase_city
  
  class << self
    # The fields to be exported to the file which is later imported into SAP. This list
    # of attributes is in the order SAP expects to see them.
    def export_fields 
      %w{title first_name last_name middle_initial company jobtitle address1 city state zip country phone fax
        email subscribe brand_name model serial_number registered_on purchased_on purchased_from purchase_city purchase_country
        purchase_price age marketing_question1 marketing_question2 marketing_question3 marketing_question4 marketing_question5
        marketing_question6 marketing_question7 comments}
    end
  end
  
  # This could be used to automatically send registrants promotion materials
  # after they've registered a product. (ie, Jamplay.com discount code)
  def execute_promotion
    begin
      self.product.promotions.where(send_post_registration_message: true).all.each do |promo|
        if self.created_at.to_date >= promo.start_on.to_date && self.created_at.to_date <= promo.end_on.to_date
          SiteMailer.delay.promo_post_registration(self, promo)
        end
      end
    rescue 
      logger.debug "problem executing a promotion"
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
  
  # model
  def model
    begin
      self.product.sap_sku.upcase
    rescue
      ""
    end
  end
  
end
