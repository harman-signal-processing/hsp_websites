FactoryBot.define do
  factory :feature do
    featurable_type "ProductFamily"
    featurable_id 1
    layout_style "wide"
    content_position "left"
    pre_content ""
    content "MyText"
    image { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
  end
end
