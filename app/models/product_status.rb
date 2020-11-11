class ProductStatus < ApplicationRecord
  has_many :products
  acts_as_list

  class << self

    def simplified_options
      where.not("name LIKE '#_%' ESCAPE '#'").order(:position).map do |ps|
        [ps.simplified_name, ps.id]
      end
    end

    def current
      @current ||= where(show_on_website: true).where("discontinued != 1")
    end

    def current_ids
      @current_ids ||= current.pluck(:id)
    end

    def discontinued
      @discontinued ||= where(discontinued: true)
    end

    def discontinued_ids
      @discontinued_ids ||= discontinued.pluck(:id)
    end

    def current_and_discontinued
      @current_and_discontinued ||= current + discontinued
    end

    def current_and_discontinued_ids
      @current_and_discontinued_ids ||= current_and_discontinued.pluck(:id)
    end

    def clear_instance_variables
      @current = nil
      @current_ids = nil
      @discontinued = nil
      @discontinued_ids = nil
      @current_and_discontinued = nil
      @current_and_discontinued_ids = nil
    end

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

  def simplified_name
    n = name
    n += " (hidden from public)" if is_hidden?
    n += " (not supported)" if not_supported? && !is_hidden?
    n
  end

end
