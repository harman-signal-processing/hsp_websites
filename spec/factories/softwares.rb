FactoryBot.define do
 
  factory :software do
    name { "CoolGUI" }
    ware_file_name { "cool_gui.exe" }
    ware_file_size { 100000 }
    ware_content_type { "application/executable" }
    ware_updated_at { 5.months.ago }
    download_count { 100 }
    version { "1.2.2" }
    description { "The coolest GUI" }
    platform { "Windows" }
    active { true }
    category { "Desktop GUI" }
    brand
    factory :software_for_activation do
      multipliers { "[
  {even: 0xf31a29b0, odd: 0xf33a29b3},
  {even: 0x01fa39b1, odd: 0x7319b9b7},
  {even: 0xcc232774, odd: 0xd6661891}
]" }
      activation_name { "cool_plugin" }
    end
  end

  factory :product_software do
  	product
  	software
  end

end