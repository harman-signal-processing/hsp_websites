class AmxDxlinkDeviceInfo < ApplicationRecord
  has_many :rx_associations, dependent: :destroy, :class_name => 'AmxDxlinkCombo', :foreign_key => 'tx_id'
  has_many :tx_associations, dependent: :destroy, :class_name => 'AmxDxlinkCombo', :foreign_key => 'rx_id'

  scope :rx_available_to_pair, ->(dxlink_device) {
    available_recievers = []
    if (dxlink_device.type_short_name == "tx")
      all_rx_device_ids = AmxDxlinkDeviceInfo.where("type_short_name = 'rx'").pluck(:id)
      existing_rx_pairings = AmxDxlinkCombo.where("tx_id = ?", dxlink_device.id).pluck(:rx_id)
      rx_ids_to_return = all_rx_device_ids - existing_rx_pairings 
      available_recievers = self.where("id in (?) and type_short_name='rx'", rx_ids_to_return).order(:model)
    end
    available_recievers
  }

  scope :tx_available_to_pair, ->(dxlink_device) {
    # available_transmitters = []
    if (dxlink_device.type_short_name == "rx")
      all_tx_device_ids = AmxDxlinkDeviceInfo.where("type_short_name = 'tx'").pluck(:id)
      existing_tx_pairings = AmxDxlinkCombo.where("rx_id = ?", dxlink_device.id).pluck(:tx_id)
      tx_ids_to_return = all_tx_device_ids - existing_tx_pairings
      available_transmitters = self.where("id in (?) and type_short_name='tx'", tx_ids_to_return).order(:model)
    end
    available_transmitters
  }

  def model_with_family
    "#{model} (#{model_family})"
  end

end  #  class AmxDxlinkDeviceInfo < ApplicationRecord

