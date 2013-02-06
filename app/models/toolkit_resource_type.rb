class ToolkitResourceType < ActiveRecord::Base
  attr_accessible :name, :position, :related_model #, :related_attribute
  validate :name, presence: :true
  has_many :toolkit_resources
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100

  def self.menu_items(brand)
  	where("position > 0").order(:position).select{|trt| trt if trt.toolkit_resources.where(brand_id: brand.id).count > 0}
  end
end
