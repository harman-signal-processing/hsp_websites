require "rails_helper"

RSpec.describe "artists/index.html.erb", as: :view do

  before :all do
    @website = FactoryBot.create(:website_with_products, folder: "digitech")
    @brand = @website.brand
    @affiliate_tier = FactoryBot.create(:affiliate_tier)
    @top_tier = FactoryBot.create(:top_tier)
    artist_attr = FactoryBot.attributes_for(:artist, featured: true)
    @artist = Artist.new(artist_attr)
    @artist.artist_tier = @top_tier
    @artist.skip_unapproval = true
    @artist.approver_id = 99
    @artist.initial_brand = @brand
    @artist.skip_confirmation!
    @artist.save!
    FactoryBot.create(:artist_brand, artist: @artist, brand: @brand)
    FactoryBot.create(:artist_product, product: @website.products.first, artist: @artist)
    assign(:featured_artists, [@artist])
  end

  after :all do
    DatabaseCleaner.clean_with :deletion
  end

  before :each do
    allow(view).to receive(:website).and_return(@website)

    render
  end

  # This appears in the feature area now, so not on this view
  #it "should show the featured artist" do
  #  expect(rendered).to have_xpath("//img[@src='#{@artist.artist_photo.url(:feature)}']")
  #end

  it "should not have a signup form" do
    expect(rendered).not_to have_link "Become a #{@brand.name} Artist"
  end

end
