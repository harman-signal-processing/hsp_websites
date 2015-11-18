require "rails_helper"

RSpec.describe MainController do

  before :all do
    @website = FactoryGirl.create(:website_with_products)
    @brand = @website.brand
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET index" do

    it "assigns next event" do
      event = 1.week.from_now.to_s
      FactoryGirl.create(:setting, name: 'countdown_next_event', brand: @brand, string_value: event)

      get :index

      expect(assigns(:next_event).to_s).to eq event
    end

    it "recovers when no youtube info is found" do
      allow(@website).to receive(:value_for).with('countdown_next_event').and_return('')
      allow(@website).to receive(:value_for).with('countdown_container').and_return('foo')
      expect(@website).to receive(:value_for).with('youtube').and_raise
      allow(controller).to receive(:website).and_return(@website)

      get :index

      expect(assigns(:youtube)).to be(false)
    end

    it "renders the teaser" do
      allow(@website).to receive(:value_for).with('countdown_next_event').and_return('')
      allow(@website).to receive(:value_for).with('countdown_container').and_return('foo')
      allow(@website).to receive(:value_for).with('youtube').and_return('yomama')
      expect(@website).to receive(:teaser).and_return(1)
      allow(controller).to receive(:website).and_return(@website)

      get :index

      expect(response).to render_template('teaser')
    end

    it "renders XML" do
      get :index, format: :xml

      expect(response.content_type).to match 'xml'
    end

  end

  describe "GET sitemap" do
    it "defines @pages and renders the template" do
      locale_url = locale_sitemap_url(locale: "en-US", format: 'xml')

      get :sitemap, format: :xml

      expect(assigns(:pages).map{|p| p[:url]}).to include( locale_url )
      expect(response.content_type).to match 'xml'
      expect(response).to render_template('sitemap_index')
    end
  end

  describe "GET rss" do
    it "defines @news and renders the template" do
      news = FactoryGirl.create(:news, brand: @brand)

      get :rss, format: :xml

      expect(assigns(:news)).to include(news)
      expect(response.content_type).to match 'xml'
      expect(response).to render_template('rss')
    end
  end

  describe "GET email_signup" do
    it "assigns @src and renders the template" do
      get :email_signup, email: "foo@foo.com"

      expect(assigns(:src)).to include('foo@foo.com')
      expect(response).to render_template('email_signup')
    end
  end

  describe "GET site_info" do
    it "renders inline site details" do
      get :site_info

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET where_to_buy" do
    it "assigns @countries and renders the template" do
      distributor = FactoryGirl.create(:distributor, country: "Mexico")
      distributor.brands << @brand

      get :where_to_buy

      expect(assigns(:countries).pluck(:country)).to include("Mexico")
      expect(response).to render_template('where_to_buy')
    end
  end

  describe "GET where_to_buy with params" do
    before do
      allow_any_instance_of(Dealer).to receive(:geocode_address).and_return(true)
      @dealer = FactoryGirl.create(:dealer)
      @brand.dealers << @dealer
    end

    it "recovers from Geocoding errors" do
      expect(Geokit::Geocoders::MultiGeocoder).to receive(:geocode).with(@dealer.zip.reverse).and_raise

      get :where_to_buy, zip: @dealer.zip.reverse

      expect(response).to redirect_to(where_to_buy_path)
    end

    it "assigns dealers with exact match zipcode" do
      expect(Geokit::Geocoders::MultiGeocoder).to receive(:geocode).with(@dealer.zip).and_return(Geokit::GeoLoc.new(lat: 11.1, lng: 22.2))
      #expect(@brand.dealers).to receive(:near).and_return(@brand.dealers)

      get :where_to_buy, zip: @dealer.zip

      expect(assigns(:results)).to include(@dealer)
      expect(assigns(:js_map_loader)).to match(/map_init/)
      expect(response).to render_template('where_to_buy')
    end
  end

  describe "GET community" do
    it "renders the template" do
      get :community

      expect(response).to render_template('community')
    end
  end

  describe "GET favicon" do
    it "checks for brand-specific favicon" do
      allow(@website).to receive(:folder).and_return('dbx')
      allow(controller).to receive(:website).and_return(@website)
      expect(File).to receive(:exists?).and_return(true)

      get :favicon

      expect(response.content_type).to match 'image'
    end

    it "defaults to harman icon" do
      get :favicon

      expect(response.content_type).to match 'image'
    end
  end

  describe "GET channel" do
    it "renders inline channel content" do
      get :channel

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET robots.txt" do
    it "renders the dynamic robots.txt file" do
      get :robots, format: :txt

      expect(response.content_type).to match 'text'
    end
  end

  describe "POST search" do

    it "assigns search results" do
      expect(ThinkingSphinx).to receive(:search).and_return(@website.products)

      post :search, query: "test"

      expect(assigns(:results)).to include(@website.products.first)
      expect(response).to render_template('search')
    end

  end
end
