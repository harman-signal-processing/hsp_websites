FactoryBot.define do

  factory :setting do
    name "SettingName"
    string_value "SettingValue"
    setting_type "string"
    brand
  end

end
