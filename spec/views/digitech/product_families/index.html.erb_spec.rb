require "rails_helper"

RSpec.describe "digitech/product_families/index.html.erb", as: :view do

  before :all do
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand)
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

  it "should not link to full line where no child families exist" do
    expect(rendered).not_to have_link(I18n.t('view_full_line'), href: product_family_path(@product_family))
  end

  it "should link to full line where child families exist" do
    expect(rendered).to have_link(I18n.t('view_full_line'), href: product_family_path(@multiple_parent))
  end

  it "should not link to full line for a family with one product in one sub-family" do
    expect(rendered).not_to have_link(I18n.t('view_full_line'), href: product_family_path(@single_parent))
  end

end
