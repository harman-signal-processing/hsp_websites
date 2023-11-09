require 'rails_helper'

RSpec.describe "news/show", :type => :view do
  before :all do
    @website = FactoryBot.create(:website)
    @news = FactoryBot.create(:news)
    @product = FactoryBot.create(:product, brand: @website.brand)
    @news.brands << @website.brand
    @news.products << @product

    assign(:related_news, [])
    assign(:recent_news, [])
    assign(:news, @news)
  end

  before :each do
    allow(view).to receive(:current_user).and_return(User.new)
    allow(view).to receive(:can?).and_return(false)
    allow(view).to receive(:website).and_return(@website)
  end

  it "should link to related products" do
    render
    expect(rendered).to have_link(@product.name, href: product_url(@product))
  end

  it "should NOT have a compare checkbox" do
    render
    expect(rendered).not_to have_css("#product_ids_[value='#{@product.to_param}']")
  end

  it "should show related news if any" do
    related_story = FactoryBot.create(:news)
    related_story.brands << @website.brand
    assign(:related_news, [related_story])
    render

    expect(rendered).to have_text("Related #{@website.brand.name} News")
    expect(rendered).to have_link(related_story.title, href: news_path(related_story))
  end

  it "should show recent news if no related news available" do
    recent_story = FactoryBot.create(:news)
    recent_story.brands << @website.brand
    assign(:related_news, [])
    assign(:recent_news, [recent_story])
    render

    expect(rendered).not_to have_text("Related #{@website.brand.name} News")
    expect(rendered).to have_link(recent_story.title, href: news_path(recent_story))
  end


end
