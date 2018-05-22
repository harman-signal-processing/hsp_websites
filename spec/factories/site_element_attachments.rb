FactoryBot.define do
  factory :site_element_attachment do
    site_element
    attachment { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
  end
end
