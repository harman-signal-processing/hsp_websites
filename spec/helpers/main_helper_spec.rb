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

  describe "youtube_feed()" do

    # stubbing youtube response
    before do
      @thumbnail = {"default" => {"url" => "thumbnail_url"}}
      @thumbnails = @thumbnail
      video_item = {
        "snippet" => {
          "thumbnails" => @thumbnails,
          "title" => "Video Title",
          "resourceId" => {
            "videoId" => 1
          }
        }
      }
      @video_list = {"items" => [video_item]}
    end

    it "renders the feed as a table" do
      allow(@thumbnails).to receive(:find).and_return(@thumbnails)
      expect(helper).to receive(:get_default_playlist_id).and_return("abcdefg")
      expect(helper).to receive(:get_video_list_data).and_return(@video_list)

      content = helper.youtube_feed("testuser")

      expect(content).to have_css("tr")
      expect(content).to have_xpath("//img[@src='thumbnail_url']")
    end

    it "renders the feed as a div" do
      allow(@thumbnails).to receive(:find).and_return(@thumbnails)
      expect(helper).to receive(:get_default_playlist_id).and_return("abcdefg")
      expect(helper).to receive(:get_video_list_data).and_return(@video_list)

      content = helper.youtube_feed("testuser", style: "div")

      expect(content).to have_css("div.video_thumbnail")
    end

    it "renders a simple link if there are no videos" do
      allow(helper).to receive(:get_default_playlist_id).and_return("abcdefg")
      allow(helper).to receive(:get_video_list_data).and_return([])

      expect(helper.youtube_feed("testuser")).to have_link("YouTube Channel")
    end

    describe "horizontal_youtube_feed" do
      it "renders the horizontal feed" do
        allow(@thumbnails).to receive(:find).and_return(@thumbnails)
        expect(helper).to receive(:get_default_playlist_id).and_return("abcdefg")
        expect(helper).to receive(:get_video_list_data).and_return(@video_list)

        content = helper.horizontal_youtube_feed("testuser", {})

        expect(content).to have_css("ul#video_list")
        expect(content).to have_css("li.video_thumbnail")
      end

      it "renders a simple link" do
        allow(helper).to receive(:get_default_playlist_id).and_return("abcdefg")
        allow(helper).to receive(:get_video_list_data).and_return([])

        expect(helper.horizontal_youtube_feed("testuser", {})).to have_link("YouTube Channel")
      end
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
