require "rails_helper"

RSpec.describe "artists/show.html.erb", as: :view do

  before :all do
    @website = FactoryGirl.create(:website_with_products, folder: "digitech")
    @brand = @website.brand
    @affiliate_tier = FactoryGirl.create(:affiliate_tier)
    @top_tier = FactoryGirl.create(:top_tier)
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  before :each do
    allow(view).to receive(:website).and_return(@website)
    allow(view).to receive(:current_user).and_return(User.new)
    allow(view).to receive(:can?).and_return(false)
  end

  describe "Affiliate" do
    before do
      artist_attr = FactoryGirl.attributes_for(:artist, featured: true)
      @artist = Artist.new(artist_attr)
      @artist.artist_tier = @affiliate_tier
      @artist.skip_unapproval = true
      @artist.approver_id = 99
      @artist.initial_brand = @brand
      @artist.skip_confirmation!
      @artist.save!
      FactoryGirl.create(:artist_brand, artist: @artist, brand: @brand)
      FactoryGirl.create(:artist_product, product: @website.products.first, artist: @artist)

      assign(:artist, @artist)

      render
    end

    it "should NOT have the big pic banner" do
      expect(rendered).not_to have_xpath("//div[@id='big_artist_photo']/img[@src='#{@artist.artist_photo.url(:feature)}']")
    end
  end

  describe "Top-tier" do
    before do
      artist_attr = FactoryGirl.attributes_for(:artist, featured: true)
      @artist = Artist.new(artist_attr)
      @artist.artist_tier = @top_tier
      @artist.skip_unapproval = true
      @artist.approver_id = 99
      @artist.initial_brand = @brand
      @artist.skip_confirmation!
      @artist.save!
      FactoryGirl.create(:artist_brand, artist: @artist, brand: @brand)
      FactoryGirl.create(:artist_product, product: @website.products.first, artist: @artist)

      assign(:artist, @artist)

      render
    end

    it "should have the big pic banner" do
      expect(rendered).to have_xpath("//div[@id='big_artist_photo']/img[@src='#{@artist.artist_photo.url(:feature)}']")
    end

  end
end
