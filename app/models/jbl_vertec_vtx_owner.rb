class JblVertecVtxOwner < ApplicationRecord
  before_save :check_for_state
  validates :company_name, 
  :address, 
  :city, 
  :postal_code, 
  :country, 
  :phone, 
  :email, 
  :contact_name, 
  :rental_products, presence: true
  attribute :vertec_products
  attribute :vtx_products
  
  def check_for_state
    if self.country == "United States of America" && self.state.nil?
      geo = Geokit::Geocoders::MultiGeocoder.geocode(postal_code)
      self.state = geo.state
    end
  end
end  #  class JblVertecVtxOwner < ApplicationRecord
