FactoryBot.define do
  factory :brand_solution_featured_product do
    brand
    solution
    product
    name "MyString"
    link "http://foo.com/"
    description "MyText"
    image { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
  end
end
