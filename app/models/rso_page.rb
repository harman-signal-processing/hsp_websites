class RsoPage < ActiveRecord::Base
  belongs_to :brand
  validates :name, :presence => true
  attr_accessor :add_to_nav, :add_to_left_panel
  after_create :create_rso_navigation
  
  def full_url
    "http://#{RSO_HOST}#{self.relative_url}"
  end
  
  def relative_url
    "/brands/#{self.brand.to_param}/rso_pages/#{self.id}"
  end
  
  def create_rso_navigation
    if self.add_to_nav
      RsoNavigation.find_or_create_by_brand_id_and_name_and_url(self.brand_id, self.name, self.relative_url)
    end
    if self.add_to_left_panel
      panel = RsoPanel.find_or_create_by_brand_id_and_name(self.brand_id, "left")
      RsoNavigation.create(:brand_id => self.brand_id, :rso_panel_id => panel.id, :name => self.name, :url => self.relative_url)
    end
  end
  
end
