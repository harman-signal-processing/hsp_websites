FactoryBot.define do

  # FactoryBot.create(:product_family_with_products, products_count: 10)
  factory :product_family do
    name { "Super Signal Processors" }
    brand
    factory :product_family_with_products do
      transient do
        products_count { 2 }
      end
      after(:create) do |product_family, evaluator|
        FactoryBot.create_list(:product, evaluator.products_count, brand: product_family.brand).each do |product|
          FactoryBot.create(:product_family_product, product_family: product_family, product: product)
        end
      end
    end
  end

  factory :product_family_product do
    product_family
    product
    sequence(:position)
  end

  factory :product_status do
    sequence(:name) {|n| "Status Name #{n}"}
    discontinued { false }
    show_on_website { true }
    shipping { true }
  end

  factory :product do
    sequence(:name) {|n| "RP#{n}"}
    product_status
    brand
    description { "This is the bestest widget we ever did make." }
    factory :discontinued_product do
      association :product_status, factory: :product_status, discontinued: true
    end
    factory :secret_product do
      association :product_status, factory: :product_status, discontinued: false, show_on_website: false, shipping: false
    end
  end

  factory :product_attachment do
    product
    primary_photo { false }
    product_attachment { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
    position { 1 }
  end

  factory :product_document do
    product
    language { "en" }
    document_type { "owners_manual" }
    document_file_name { File.new(Rails.root.join('spec', 'fixtures', 'test.pdf')) }
  end
end
