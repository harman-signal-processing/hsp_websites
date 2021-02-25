class AmxDxlinkAttributeName < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :amx_dxlink_combo_attributes, :class_name => "AmxDxlinkComboAttribute", dependent: :destroy, foreign_key: 'amx_dxlink_attribute_name_id'
end

