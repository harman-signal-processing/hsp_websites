FactoryBot.define do
  factory :product_type do
    name { "MyString" }
    default { false }
    digital_ecom { false }
    factory :standard_product_type do
      name { "Standard" }
      default { true }
    end
    factory :ecommerce_digital_download_product_type do
      name { "Ecommerce-Digital Download" }
      digital_ecom { true }
    end
    factory :product_types do
      before(:create) do
        create(:standard_product_type)
        create(:ecommerce_digital_download_product_type)
      end
    end
  end
end
