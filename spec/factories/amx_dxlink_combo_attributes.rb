FactoryBot.define do
  factory :amx_dxlink_combo_attribute do
    amx_dxlink_attribute_name { AmxDxlinkAttributeName.create(name: "Resolution") }
    value { "1080p60" }
    amx_dxlink_combo { AmxDxlinkCombo.create(tx_id: AmxDxlinkDeviceInfo.create(model: 'DX-TX').id, rx_id: AmxDxlinkDeviceInfo.create(model: 'DX-RX').id) }
  end
end
