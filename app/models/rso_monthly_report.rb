# RSO = Regional Sales Office. This and the other "RSO" models make up an
# attempt to communicate with our centralized Salespersons. It is unclear
# whether or not they'll actually use this.
# 
# If this is abandoned at some point, be sure to remove the RSO items
# from the brand.rb file
#
class RsoMonthlyReport < ActiveRecord::Base
  belongs_to :brand
  belongs_to :user, class_name: "User", foreign_key: "updated_by_id"
  validates :name, presence: true, uniqueness: {scope: :brand_id}
  has_attached_file :rso_report,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  attr_accessor :add_to_panel
  after_create :create_panel_link
  
  def full_url
    "http://#{RSO_HOST}#{self.relative_url}"
  end
  
  def relative_url
    "/brands/#{self.brand.to_param}/rso_monthly_reports/#{self.id}"
  end
  
  def create_panel_link
    if self.add_to_panel
      panel = RsoPanel.find_or_create_by_brand_id_and_name(self.brand_id, "left")
      RsoNavigation.create(brand_id: self.brand_id, rso_panel_id: panel.id, name: self.name, url: self.relative_url)
    end
  end
  
end
