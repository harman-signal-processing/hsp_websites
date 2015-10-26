require "rails_helper"

RSpec.describe ArtistsController, type: :controller do

  before :all do
    @website = FactoryGirl.create(:website_with_products)
    @artist = FactoryGirl.create(:artist,
                                 products: @website.products,
                                 initial_brand: @website.brand,
                                 featured: true
                                )
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET index" do
    before do
      get :index
    end

    it "assigns @featured_artists" do
      expect(assigns(:featured_artists)).to include(@artist)
    end

    it "renders the index" do
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end

  describe "GET index for a brand without artists" do
    it "redirects to root" do
      website = FactoryGirl.create(:website)
      brand = website.brand
      brand.update_attributes(has_artists: false)
      @request.host = website.url

      get :index

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET list" do
    it "redirects to index" do
      get :list

      expect(response).to redirect_to(artists_path)
    end
  end

  describe "GET become" do
    it "renders the signup form" do
      get :become

      expect(response).to render_template(:become)
    end
  end

  describe "GET touring" do
    before do
      get :touring
    end

    it "finds the products on tour" do
      expect(assigns(:products)).to be_an(Array)
    end

    it "renders the template" do
      expect(response).to render_template(:touring)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    before do
      get :show, id: @artist.id
    end

    it "assigns @artist" do
      expect(assigns(:artist)).to eq(@artist)
    end

    it "renders the template" do
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end
  end

  describe "GET show for an artist not related to the brand" do
    it "redirects to artists path" do
      other_artist = FactoryGirl.create(:artist, artist_tier: @artist.artist_tier)

      get :show, id: other_artist.id

      expect(response).to redirect_to(artists_path)
    end
  end

  describe "GET show for a non-featured artist" do
    it "redirects to the corresponding alphabetical page" do
      affiliate_tier = ArtistTier.find_by(name: "Affiliate") || FactoryGirl.create(:affiliate_tier, invitation_code: "affili111")
      wannabe_artist = FactoryGirl.create(:artist,
                                          featured: false,
                                          artist_tier: affiliate_tier,
                                          products: @website.products,
                                          initial_brand: @website.brand)

      get :show, id: wannabe_artist.id

      expect(response).to redirect_to(all_artists_path(letter: wannabe_artist.name.match(/\w/).to_s.downcase))
    end
  end

  describe "GET all" do
    before do
      get :all, letter: @artist.name.match(/\w/).to_s.downcase
    end

    it "assigns @artists" do
      expect(assigns(:artists)).to include(@artist)
    end

    it "renders the template" do
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:all)
    end
  end

end
