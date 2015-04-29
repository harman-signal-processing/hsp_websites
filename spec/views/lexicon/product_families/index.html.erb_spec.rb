require "rails_helper"

RSpec.describe "lexicon/product_families/index.html.erb", as: :view do

  before :all do
    @brand = FactoryGirl.create(:lexicon_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "lexicon", brand: @brand)
    @product_family = @website.product_families.first
    @multiple_parent = FactoryGirl.create(:product_family, brand: @website.brand)
    2.times { FactoryGirl.create(:product_family_with_products, brand: @website.brand, parent_id: @multiple_parent.id)}
    @single_parent = FactoryGirl.create(:product_family, brand: @website.brand)
    FactoryGirl.create(:product_family_with_products, brand: @website.brand, parent_id: @single_parent.id, products_count: 1)
    FactoryGirl.create(:product_family, brand: @website.brand, parent_id: @single_parent.id)

    assign(:product_families, @website.product_families)
    assign(:discontinued_products, [])
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  before :each do
    allow(view).to receive(:website).and_return(@website)

    render
  end

  it "should link to each parent family" do
    expect(rendered).to have_link @product_family.name, href: product_family_path(@product_family, locale: I18n.default_locale)
    expect(rendered).to have_link @multiple_parent.name, href: product_family_path(@multiple_parent, locale: I18n.default_locale)
    expect(rendered).to have_link @single_parent.name, href: product_family_path(@single_parent, locale: I18n.default_locale)
  end

end
