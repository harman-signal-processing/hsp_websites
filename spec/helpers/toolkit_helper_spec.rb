require "rails_helper"

RSpec.describe ToolkitHelper do

  before :all do
    @website = FactoryGirl.create(:website_with_products)
    @brand = @website.brand
    @brand.update_attributes(toolkit: true)
    @product = @website.products.first
    @toolkit_resource_type = FactoryGirl.create(:toolkit_resource_type, related_model: "Product")
    @toolkit_resource = FactoryGirl.create(:toolkit_resource,
                                           brand: @brand,
                                           toolkit_resource_type: @toolkit_resource_type,
                                           related_id: @product.id)
  end

  before :each do
    ability = Object.new
    ability.extend(CanCan::Ability)
    ability.can :read, :all
    allow(helper).to receive(:current_ability).and_return(ability)
  end

  describe "toolkit_brands" do
    it "returns a set of brands" do
      non_toolkit_brand = FactoryGirl.create(:brand, toolkit: false)
      @toolkit_brands = helper.toolkit_brands

      expect(@toolkit_brands).to include(@brand)
      expect(@toolkit_brands).not_to include(non_toolkit_brand)
    end
  end

  describe "bgoffset" do
    it "gives a css class if the brand has a twitter background causing the content to be shifted" do
      expect(helper.bgoffset).to be(nil)
    end
  end

  describe "toolkit_support_files(object)" do
    it "gathers (all) resources" do
      files = helper.toolkit_support_files(@product)

      expect(files).to include(@toolkit_resource)
    end

    it "excludes certain resources with 'exclude'" do
      files = helper.toolkit_support_files(@product, exclude: @toolkit_resource_type.name)

      expect(files).not_to include(@toolkit_resource)
    end

    it "includes certain resources with 'only'" do
      files = helper.toolkit_support_files(@product, only: @toolkit_resource_type.name)

      expect(files).to include(@toolkit_resource)
    end
  end

  describe "list_toolkit_support_files_for(object)" do
    it "returns an UL with links to resources" do
      content = helper.list_toolkit_support_files_for(@product, @brand)

      expect(content).to have_css("ul")
      expect(content).to have_link(@toolkit_resource.name)
    end
  end

  describe "panels_of_toolkit_support_files_for(object)" do
    it "returns a panel with links to the resources" do
      content = helper.panels_of_toolkit_support_files_for(@product, @brand)

      expect(content).to have_css("div.panel")
      expect(content).to have_link(@toolkit_resource.name)
    end
  end

  describe "rows_of_panels_of_toolkit_support_files_for(object)" do
    it "returns rows of panels with links" do
      content = helper.rows_of_panels_of_toolkit_support_files_for(@product, @brand)

      expect(content).to have_css("div.panel")
      expect(content).to have_link(@toolkit_resource.name)
    end
  end

  describe "icon_for(item)" do
    it "returns the pdf icon" do
      @toolkit_resource.download_path = "test.pdf"

      expect(helper.icon_for(@toolkit_resource)).to match "pdf-icon.png"
    end

    it "returns the zip icon" do
      @toolkit_resource.download_path = "test.zip"

      expect(helper.icon_for(@toolkit_resource)).to match "zip-icon.png"
    end

    it "returns the windows icon" do
      @toolkit_resource.download_path = "test.exe"

      expect(helper.icon_for(@toolkit_resource)).to match "windows_17.png"
    end

    it "returns the mac icon" do
      @toolkit_resource.download_path = "test.dmg"

      expect(helper.icon_for(@toolkit_resource)).to match "mac_17.png"
    end

    it "returns the mp3 icon" do
      @toolkit_resource.download_path = "test.mp3"

      expect(helper.icon_for(@toolkit_resource)).to match "icon_play.png"
    end

    it "returns the video icon" do
      @toolkit_resource.download_path = "test.mp4"

      expect(helper.icon_for(@toolkit_resource)).to match "icon_play.png"
    end

    it "returns no icon for unknowns" do
      @toolkit_resource.download_path = "test.zbzbzb"

      expect(helper.icon_for(@toolkit_resource).blank?).to be(true)
    end

  end
end
