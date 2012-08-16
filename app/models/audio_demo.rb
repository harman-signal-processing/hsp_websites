class AudioDemo < ActiveRecord::Base
  has_many :product_audio_demos, dependent: :destroy
  has_many :products, through: :product_audio_demos
  validates :name, presence: true
  has_attached_file :dry_demo,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  has_attached_file :wet_demo,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

end
