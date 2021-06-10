class CustomShopCart < ApplicationRecord
  has_many :custom_shop_line_items, dependent: :destroy
  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def total_items
    custom_shop_line_items.inject(0){ |t,i| t += i.quantity }
  end

  def empty?
    total_items == 0
  end

end
