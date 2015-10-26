require "rails_helper"

RSpec.describe VideosHelper do

  describe "related_product_links_for_video" do
    it "shows links when there are related products found" do
      website = FactoryGirl.create(:website_with_products)
      product = website.products.first
      expect(helper).to receive(:website).and_return(website)

      video = Hash.new
      video['tags'] = [product.name]

      content = helper.related_product_links_for_video(video)

      expect(content).to have_content("Related Products")
      expect(content).to have_link(product.name)
    end

    it "shows nothing when no related products are found" do
      video = Hash.new('tags' => '')

      expect(helper.related_product_links_for_video(video)).to eq ""
    end
  end
end
