require 'rails_helper'

RSpec.describe "news/show.html.erb", :type => :view do
  before :all do
    @website = FactoryGirl.create(:website)
    @news = FactoryGirl.create(:news, brand: @website.brand)
    @product = FactoryGirl.create(:product, brand: @website.brand)
    @news.products << @product

    assign(:recent_news, [])
    assign(:news, @news)
  end

  before :each do
    allow(view).to receive(:current_user).and_return(User.new)
    allow(view).to receive(:can?).and_return(false)
    allow(view).to receive(:website).and_return(@website)
    render
  end

  it "should link to related products" do
    expect(rendered).to have_link(@product.name, href: product_url(@product))
  end

  it "should NOT have a compare checkbox" do
    expect(rendered).not_to have_css("#product_ids_[value='#{@product.to_param}']")
  end

end
