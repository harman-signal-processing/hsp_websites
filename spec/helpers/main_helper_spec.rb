require "rails_helper"

RSpec.describe MainHelper do

  describe "link_to_function()" do
    it "renders a link to a javascript function" do
      content = helper.link_to_function('link name', 'function()')

      expect(content).to have_link 'link name', href: '#'
    end
  end

  describe "feature_button()" do

    before do
      @feature = FactoryBot.build_stubbed(:setting, slide: File.open(Rails.root.join("spec/fixtures/test.jpg")))
    end

    it "renders the image" do
      @feature.string_value = ''

      content = helper.feature_button(@feature)

      expect(content).to have_xpath("//img[@src='#{ @feature.slide.url }']")
    end

    it "renders a link of the setting has an external link" do
      @feature.string_value = 'http://foo.com'

      content = helper.feature_button(@feature)

      expect(content).to have_xpath("//a[@href='#{ @feature.string_value }']")
    end

    it "renders a relative link" do
      @feature.string_value = '/yo/mama'

      content = helper.feature_button(@feature)

      expect(content).to have_xpath("//a[@href='#{ @feature.string_value }']")
    end

    it "renders a locale-aware link" do
      @feature.string_value = "products/rp99"

      content = helper.feature_button(@feature)

      expect(content).to have_xpath("//a[@href='//#{ @feature.string_value }']")
    end

    it "should append more info if it is a carousel image" do
      @feature.text_value = "The best thing we ever made is here..."

      content = helper.feature_button(@feature, carousel: true)

      expect(content).to have_content @feature.name
      expect(content).to have_content @feature.text_value
      expect(content).to have_content 'LEARN MORE'
    end
  end

  describe "preload_background_images()" do
    it "returns a 0-sized image" do
      website = FactoryBot.create(:website_with_products)
      product = website.products.first
      product.update_attributes(background_image: File.open(Rails.root.join("spec/fixtures/test.jpg")))

      expect(helper).to receive(:website).and_return(website)
      content = helper.preload_background_images

      expect(content).to have_xpath("//img[@src='#{ product.background_image.url }']")
    end

    it "recovers from errors" do
      expect(helper.preload_background_images).to eq ''
    end
  end

end
