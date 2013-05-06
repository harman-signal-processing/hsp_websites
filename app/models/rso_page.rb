class RsoPage < ActiveRecord::Base
  belongs_to :brand
  validates :name, presence: true
  attr_accessor :add_to_nav, :add_to_left_panel
  after_create :create_rso_navigation
  
  def full_url
    "http://#{HarmanSignalProcessingWebsite::Application.config.rso_host}#{self.relative_url}"
  end
  
  def relative_url
    "/brands/#{self.brand.to_param}/rso_pages/#{self.id}"
  end
  
  def create_rso_navigation
    if self.add_to_nav
      RsoNavigation.where(brand_id: self.brand_id, name: self.name, url: self.relative_url).first_or_create
    end
    if self.add_to_left_panel
      panel = RsoPanel.where(brand_id: self.brand_id, name: "left").first_or_create
      RsoNavigation.create(brand_id: self.brand_id, rso_panel_id: panel.id, name: self.name, url: self.relative_url)
    end
  end
  
end
