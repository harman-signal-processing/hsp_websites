class Distributor < ActiveRecord::Base
  validates :name, :country, presence: true
  validates :account_number, presence: true, uniqueness: true
  has_many :brand_distributors, dependent: :destroy
  has_many :brands, through: :brand_distributors
  has_many :distributor_users, dependent: :destroy
  has_many :users, through: :distributor_users

  def self.countries(f)
    if f.is_a?(Website)
      brand_id = f.distributors_from_brand_id || f.brand_id
    elsif f.is_a?(Brand)
      brand_id = f.id
    else
      brand_id = f
    end
    Distributor.order(:country).select("DISTINCT(distributors.country)").joins(:brand_distributors).where(["brand_distributors.brand_id = ?", brand_id])
  end
  
  def create_brand_distributor(website)
    BrandDistributor.create(brand_id: website.brand_id, distributor_id: self.id)
  end
  
  def self.find_all_by_country(country, f)
    if f.is_a?(Website)
      brand_id = f.distributors_from_brand_id || f.brand_id
    elsif f.is_a?(Brand)
      brand_id = f.id
    else
      brand_id = f
    end
    r = []
    where(country: country).each do |c|
      r << c if c.brands.collect{|b| b.id}.include?(brand_id)
    end
    r
  end
  
end
