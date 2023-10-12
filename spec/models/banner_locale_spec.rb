require 'rails_helper'

RSpec.describe BannerLocale, type: :model do

  before do
    website = create(:website)
    @banner = create(:banner, bannerable: website)
    @banner_locale = create(:banner_locale, banner: @banner, locale: I18n.default_locale)
  end

  subject { @banner_locale }
  it { should respond_to(:banner) }

  describe "#has_content?" do
    it "returns false if any key elements are missing" do
      bl = create(:banner_locale,
        banner: @banner,
        locale: "zh",
        title: nil,
        content: nil,
        slide: nil
      )

      expect(bl.has_content?).to be(false)
    end

    it "returns true when any key content is present" do
      bl = create(:banner_locale,
        banner: @banner,
        locale: "ko",
        title: "Title1",
        content: "Content"
      )

      expect(bl.has_content?).to be(true)
    end
  end
end
