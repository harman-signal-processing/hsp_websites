FactoryBot.define do
  factory :page do
    title { "This is a page title" }
    description { "This is the page description" }
    body { "This is the body of the landing page." }
    brand
  end
end

