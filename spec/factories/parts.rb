FactoryBot.define do
  factory :part do
    sequence(:part_number) {|n| "Part-#{n}"}
    description { "MyString" }
    photo { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
  end
end
