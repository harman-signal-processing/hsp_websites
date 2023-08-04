require "rails_helper"

RSpec.describe FeaturesHelper do
  before do
    @product_family = create(:product_family)
  end

  describe "render_split_feature()" do
    before do
      @feature = build_stubbed(:feature, featurable: @product_family)
    end

    it "should have an image panel and small image panel" do
      content = helper.render_split_feature(@feature)

      expect(content).to have_xpath("//div[@style='background-image: url(#{@feature.image.url});']")
      expect(content).to have_xpath("//div/img[@src='#{@feature.image.url(:large)}']")
    end

    it "should have text content" do
      @feature.content_position = "right"
      content = helper.render_split_feature(@feature)

      expect(content).to have_xpath("//div[@data-equalizer-watch='feature_#{@feature.to_param}']")
      expect(content).to have_content(@feature.content)
    end
  end

  describe "render_review_quotes_feature()" do
    before do
      @website = create(:website_with_products)
      allow(helper).to receive(:website).and_return(@website)
    end

    it "should render product review quotes" do
      product = @website.products.first
      review = create(:product_review, body: "This is a PRODUCT review")
      review.products << product
      feature = build_stubbed(:feature, featurable: product)

      content = helper.render_review_quotes_feature(feature)

      expect(content).to have_xpath("//div[@class='reviews-slider']/div[@class='slide']")
      expect(content).to have_content(review.body)
    end

    it "should render product family review quotes" do
      product = @website.products.first
      review = create(:product_review, body: "This is a PRODUCT review on a FAMILY page")
      review.products << product
      @product_family.products << product
      feature = build_stubbed(:feature, featurable: @product_family)

      content = helper.render_review_quotes_feature(feature)

      expect(content).to have_xpath("//div[@class='reviews-slider']/div[@class='slide']")
      expect(content).to have_content(review.body)
      expect(content).to have_link(product.name, href: product_path(product))
    end
  end

  describe "render_feature_text()" do
    before do
      @feature = build_stubbed(:feature, featurable: @product_family, content: "This is the feature text")
    end

    it "should render some good ol text" do
      content = helper.render_feature_text(@feature)

      expect(content).to have_xpath("//div[@class='borderless feature-text panel'][@data-equalizer-watch='feature_#{@feature.to_param}']")
      expect(content).to have_content(@feature.content)
    end

    it "should render passed in parameters" do
      content = helper.render_feature_text(@feature, format: 'mobile', text_height: "300px")

      expect(content).to have_xpath("//div[@class='borderless feature-text panel'][@style='height: 300px;overflow: hidden']")
    end

  end

  describe "update_youtube_links()" do
    it "renders content with an updated link" do
      video_id = 'VTcdTKKRkKE'
      og_content = "text text <a href=\"https://www.youtube.com/watch?v=#{video_id}\" class='test'>video</a>"

      content = update_youtube_links(og_content)

      expect(content).to have_xpath("//a[@target='_blank'][@data-videoid='#{video_id}'][@class='test start-video'][@href='http://test.host/#{I18n.default_locale}/videos/play/#{video_id}']")
    end

    it "renders content with an updated link if class is missing" do
      video_id = 'VTcdTKKRkKE'
      og_content = "text text <a href=\"https://www.youtube.com/watch?v=#{video_id}\">video</a>"

      content = update_youtube_links(og_content)

      expect(content).to have_xpath("//a[@target='_blank'][@data-videoid='#{video_id}'][@class=' start-video'][@href='http://test.host/#{I18n.default_locale}/videos/play/#{video_id}']")
    end
  end

  describe "render_pre_content()" do

    it "renders the pre-content" do
      feature = build_stubbed(:feature, featurable: @product_family, pre_content: "This is the pre content")

      content = helper.render_pre_content(feature)

      expect(content).to have_xpath("//div[@class='feature-pre']")
      expect(content).to have_content(feature.pre_content)
    end
  end

  describe "calculate_common_text_height_for_features()" do

    it "should calculate a nice height in pixels" do
      sample_content = "This is sample content"
      4.times do
        sample_content += sample_content
        create(:feature, featurable: @product_family, content: sample_content)
      end

      height = helper.calculate_common_text_height_for_features(@product_family.features)

      expect(height).to eq("323px")
    end
  end

end

