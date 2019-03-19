class ToolkitResourceType < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  validates :name, presence: true
  has_many :toolkit_resources

  def self.menu_items(brand)
  	where("position > 0").order(:position).select{|trt| trt if trt.brand_resources(brand).size > 0}
  end

  def brand_resources(brand)
  	toolkit_resources.where(brand_id: brand.id)
  end
end
