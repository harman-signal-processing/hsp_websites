class Solution < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  has_many :brand_solutions, dependent: :destroy
  has_many :brands, through: :brand_solutions
  has_many :brand_solution_featured_products, -> { order("position") }
  has_many :product_solutions, dependent: :destroy
  has_many :products, through: :product_solutions

  validates :name, presence: true, uniqueness: true

  def vertical_market
    @vertical_market ||= load_vertical_market
  end

  def load_vertical_market
    if vertical_market_id.present?
      SolutionMarket.find(vertical_market_id)
    else
      []
    end
  end

  def vertical_market_banner_url
    @vertical_market_banner_url ||= vertical_market["banner_url"]
  end

  def vertical_market_url
    @vertical_market_url ||= "#{ENV['PRO_SITE_URL']}/applications/#{vertical_market['slug']}"
  end
end
