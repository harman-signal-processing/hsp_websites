FactoryGirl.define do
 
  factory :software do
    name "CoolGUI"
    ware_file_name "cool_gui.exe"
    ware_file_size 100000
    ware_content_type "application/executable"
    ware_updated_at 5.months.ago
    download_count 100
    version "1.2.2"
    description "The coolest GUI"
    platform "Windows"
    active true
    category "Desktop GUI"
    brand
  end

  factory :product_software do
  	product
  	software
  end

end