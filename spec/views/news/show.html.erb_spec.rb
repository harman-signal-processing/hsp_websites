require 'rails_helper'

RSpec.describe "news/show.html.erb", :type => :view do
  before do
    @website = FactoryGirl.create(:website_with_products)
    @news = FactoryGirl.create(:news, brand: @website.brand)
    @product = FactoryGirl.create(:product, brand: @website.brand)
    @news.products << @product

    allow(view).to receive(:current_user).and_return(User.new)
    allow(view).to receive(:can?).and_return(false)
    allow(view).to receive(:website).and_return(@website)
    assign(:recent_news, [])
    assign(:news, @news)
    render
  end

  it "should link to related products" do
    expect(rendered).to have_link(@product.name, product_path(@product))
  end

  it "should NOT have a compare checkbox" do
    expect(rendered).not_to have_css("#product_ids_[value='#{@product.to_param}']")
  end

end
