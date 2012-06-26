class RsoPersonalReport < ActiveRecord::Base
  belongs_to :user
  has_attached_file :rso_personal_report, 
    :styles => { 
      :large => "960x600", 
      :medium => "480x360", 
      :small => "240x180",
      :thumb => "100x100", 
      :tiny => "64x64", 
      :tiny_square => "64x64#" 
    }
end
