FactoryBot.define do
  factory :access_level do
    name { "MyString" }
    distributor { false }
    dealer { false }
    technician { false }
  end
end
