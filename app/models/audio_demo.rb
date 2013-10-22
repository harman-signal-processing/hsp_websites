class AudioDemo < ActiveRecord::Base
  has_many :product_audio_demos, dependent: :destroy
  has_many :products, through: :product_audio_demos
  validates :name, presence: true
  has_attached_file :dry_demo,
    path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    url: ":asset_host/system/:attachment/:id_:timestamp/:basename_:style.:extension"

  has_attached_file :wet_demo,
    path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    url: ":asset_host/system/:attachment/:id_:timestamp/:basename_:style.:extension"

end
