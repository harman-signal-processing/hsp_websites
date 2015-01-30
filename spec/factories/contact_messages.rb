FactoryGirl.define do
  factory :contact_message do
    name "Axl Rose"
    subject "Product Question"
    email "axl@rose.com"
    product "RP2"
    product_serial_number "1234"
    operating_system "OS X"
    shipping_address "123 Anywhere"
    shipping_country "USA"
    phone "555-5555"
    message "I want candy."
    message_type "support"
  end
end