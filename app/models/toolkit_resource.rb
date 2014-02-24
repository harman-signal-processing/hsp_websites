class ToolkitResource < ActiveRecord::Base
  attr_accessible :brand_id, 
  	:download_file_size, 
  	:download_path, 
  	:name, 
  	:related_id, 
  	:tk_preview, 
  	:toolkit_resource_type_id,
    :expires_on,
    :message,
    :dealer,
    :distributor,
    :rep,
    :media,
    :rso

  has_attached_file :tk_preview, 
    styles: { lightbox: "800x600",
      large: "640x480", 
      medium: "480x360", 
      horiz_medium: "670x275",
      vert_medium: "375x400",
      medium_small: "150x225",
      small: "240x180",
      horiz_thumb: "170x80",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    }
    
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  belongs_to :brand 
  belongs_to :toolkit_resource_type 

  validate :name, presence: true 
  validate :brand_id, presence: :true 
  validate :toolkit_resource_type_id, presence: true
  validate :file_exists

  after_save :touch_related_item

  def touch_related_item
    if self.related_item
      self.related_item.touch 
    end
  end

  def related_item
  	if toolkit_resource_type.related_model.present? && related_id.present?
  		@related_item ||= toolkit_resource_type.related_model.constantize.find(related_id)
  	else
  		nil
  	end
  end

  def related_item_name
    if related_item.respond_to?(:name)
      related_item.name
    elsif related_item.respond_to?(:title)
      related_item.title
    else
      "related item..."
    end
  end

  def delete_preview
    self.tk_preview = nil
    self.save
  end

  def expired?
    expires_on.present? && expires_on.to_date < Date.today
  end

  def file_exists
    errors.add(:download_path, "doesn't exist on the content server.") unless file_exists?
  end

  def file_exists?
    tk_folder = Rails.env.production? ? Rails.root.join("../", "../", "../", "toolkits") : Rails.root.join("../", "../", "toolkit")
    File.file?(tk_folder + "/" + self.download_path)
  end
end
