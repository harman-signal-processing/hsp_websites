FactoryBot.define do
  factory :amx_dxlink_device_info do
    model { "DX-TX" }
    model_family { "Enova" }
    type_long_name { "Transmitter" }
    type_short_name { "TX" }
    product_url { "https://www.amx.com/products/dx-tx" }
    image_url { "MyString" }
  end
end
