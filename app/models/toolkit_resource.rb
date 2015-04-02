class ToolkitResource < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, slug_column: 'slug'

  has_attached_file :tk_preview, {
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
    }}.merge(S3_STORAGE)
  validates_attachment :tk_preview, content_type: { content_type: /\Aimage/i }

  belongs_to :brand
  belongs_to :toolkit_resource_type

  validates :name, presence: true
  validates :brand_id, presence: true
  validates :toolkit_resource_type_id, presence: true
  # validate :file_exists #can't actually do this since admin might not be on the content server.

  after_save :touch_related_item
  before_update :unflag_bad_links

  def tk_folder
    Rails.env.production? ? Rails.root.join("../", "../", "../", "toolkits") : Rails.root.join("../", "../", "toolkit")
  end

  def unflag_bad_links
    if link_good_was == false && self.download_path_changed? # assume it is correct
      self.link_good = true             # assume it is correct now, but...
      self.link_checked_at = 1.year.ago # schedule it to be re-checked next time the task runs
    end
  end

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
    errors.add(:download_path, "doesn't exist on the content server.") unless self.download_pathfile_exists?
  end

  def file_exists?
    File.file?(tk_folder.to_s + "/" + self.download_path)
  end

  def get_file_size
    self.download_file_size = File.size(tk_folder.to_s + "/" + self.download_path)
  end
end
