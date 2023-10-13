require 'rails_helper'

RSpec.describe Banner, type: :model do
  before do
    website = create(:website)
    @banner = create(:banner, bannerable: website)
  end

  after do
    I18n.locale = I18n.default_locale
  end

  subject { @banner }
  it { should respond_to(:bannerable) }
  it { should respond_to(:banner_locales) }

  describe "banner_locales" do
    it "should have banner locales" do
      I18n.locale = "es"
      banner_locale = create(:banner_locale,
        banner: @banner,
        locale: I18n.locale,
        title: "Hola amigo"
        )

      expect(@banner.banner_locales).to include(banner_locale)
      expect(@banner.content_for_current_locale).to eq(banner_locale)
    end
  end

  describe "default content" do
    it "should revert to default content when title and content are blank" do
      I18n.locale = "zh"
      banner_locale_zh = create(:banner_locale,
        banner: @banner,
        locale: "zh",
        title: nil,
        content: nil
        )
      banner_locale_en = create(:banner_locale,
        banner: @banner,
        locale: "zz",
        default: true,
        title: "Title1",
        content: "Slide content"
        )

      expect(@banner.content_for_current_locale.title).to eq(banner_locale_en.title)
      expect(@banner.content_for_current_locale.content).to eq(banner_locale_en.content)
    end
  end

end
