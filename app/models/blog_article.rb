class BlogArticle < ActiveRecord::Base
  belongs_to :blog
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  validates :blog_id, presence: true
  validates :title, presence: true, uniqueness: true
  extend FriendlyId
  friendly_id :sanitized_title
  
  def sanitized_title
    self.title.gsub(/[\'\"]/, "")
  end
end
