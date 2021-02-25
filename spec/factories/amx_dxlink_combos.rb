FactoryBot.define do
  factory :amx_dxlink_combo do
    recommended { false }
    notes { "MyText" }
    tx { AmxDxlinkDeviceInfo.create(model:'DX-TX') }
    rx { AmxDxlinkDeviceInfo.create(model:'DX-RX') }
  end
end
