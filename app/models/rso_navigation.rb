class RsoNavigation < ActiveRecord::Base
  belongs_to :brand
  belongs_to :rso_panel # for left-panel entries
  acts_as_list scope: 'brand_id=#{brand_id} and rso_panel_id=#{rso_panel_id}'
  validates :name, presence: true
  validates :url, presence: true
  validates :brand_id, presence: {unless: "rso_panel_id"}
end
