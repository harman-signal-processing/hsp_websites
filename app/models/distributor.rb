class Distributor < ActiveRecord::Base
  validates_presence_of :name, :country
  has_many :brand_distributors, :dependent => :destroy
  has_many :brands, :through => :brand_distributors

  def self.countries(website)
    brand_id = website.distributors_from_brand_id || website.brand_id
    Distributor.order(:country).select("DISTINCT(distributors.country)").joins(:brand_distributors).where(["brand_distributors.brand_id = ?", brand_id])
  end
  
  def create_brand_distributor(website)
    BrandDistributor.create(:brand_id => website.brand_id, :distributor_id => self.id)
  end
  
  def self.find_all_by_country(country, website)
    r = []
    brand_id = website.distributors_from_brand_id || website.brand_id
    where(:country => country).each do |c|
      r << c if c.brands.collect{|b| b.id}.include?(brand_id)
    end
    r
  end
  
end
