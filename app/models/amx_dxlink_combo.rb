class AmxDxlinkCombo < ApplicationRecord
  belongs_to :tx, :class_name => "AmxDxlinkDeviceInfo", :foreign_key  => "tx_id"
  belongs_to :rx, :class_name => "AmxDxlinkDeviceInfo", :foreign_key  => "rx_id"
  
  has_many :combo_attributes, :class_name => "AmxDxlinkComboAttribute", dependent: :destroy, foreign_key: 'amx_dxlink_combo_id'
  
  validates :tx_id, presence: true, uniqueness: {scope: :rx_id, case_sensitive: false}
  validates :rx_id, presence: true, uniqueness: {scope: :tx_id, case_sensitive: false}

  scope :ordered_by_tx_model, -> {
    joins(:tx).order("amx_dxlink_device_infos.model").uniq
  }
  scope :ordered_by_rx_model, -> {
    joins(:rx).order("amx_dxlink_device_infos.model").uniq
  }

end
