class ProductDescription < ActiveRecord::Base
  belongs_to :product, touch: true

  validates :product, presence: true
  validates :content_name, presence: true

  # Join two content fields together
  def content
    content_part1.to_s + " " + content_part2.to_s
  end

  # TODO: This is where I want to split the content into two
  # fields if it is really long. For now, just hoping it  will fit
  # in one columns.
  def content=(new_content)
    self.content_part1 = new_content
  end
end
