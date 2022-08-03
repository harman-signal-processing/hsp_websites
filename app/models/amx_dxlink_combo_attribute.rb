class AmxDxlinkComboAttribute < ApplicationRecord
  belongs_to :amx_dxlink_combo, optional: true
  belongs_to :amx_dxlink_attribute_name
  validates :amx_dxlink_attribute_name_id, presence: true, uniqueness: {scope: :amx_dxlink_combo_id, case_sensitive: false}
end
