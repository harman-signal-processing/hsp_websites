class ProductStatus < ApplicationRecord
  has_many :products

  def self.current
    @current ||= where(show_on_website: true).where("discontinued != 1")
  end

  def self.current_ids
    @current_ids ||= current.pluck(:id)
  end

  def self.discontinued
    @discontinued ||= where(discontinued: true)
  end

  def self.discontinued_ids
    @discontinued_ids ||= discontinued.pluck(:id)
  end

  def self.current_and_discontinued
    @current_and_discontinued ||= current + discontinued
  end

  def self.current_and_discontinued_ids
    @current_and_discontinued_ids ||= current_and_discontinued.pluck(:id)
  end

  def is_current?
    self.show_on_website && !self.discontinued
  end

  def is_discontinued?
    self.discontinued
  end

  def in_development?
    self.is_hidden? && !self.is_discontinued?
  end

  def is_hidden?
    !self.show_on_website
  end

  def in_production?
    is_current? && self.shipping
  end

  def not_supported?
    !self.show_on_website || self.vintage?
  end

  def vintage?
    !!(self.name.match(/vintage/i))
  end

end
