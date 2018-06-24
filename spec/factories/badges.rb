FactoryBot.define do
  factory :badge do
    sequence(:name) {|n| "Certification#{n}"}
    image { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
  end
end
