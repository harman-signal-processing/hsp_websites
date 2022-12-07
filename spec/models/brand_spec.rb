require 'rails_helper'

RSpec.describe Brand, :type => :model do

  before do
    @brand = FactoryBot.create(:brand)
  end

  subject { @brand }
  it { should respond_to :get_started_pages }
  it { should respond_to :events }

  it "should create the counter with a value of 1" do
    @brand.increment_homepage_counter

    counter = @brand.settings.where(name: 'homepage_counter').first_or_create

    expect(counter.value).to eq(1)
  end

  it "should return the new counter value" do
    expect(@brand.increment_homepage_counter).to eq(1)
  end

  it "should reset itself if the counter was last updated yesterday" do
    counter = FactoryBot.create(:setting,
                                 name: 'homepage_counter',
                                 setting_type: 'integer',
                                 integer_value: 99,
                                 brand_id: @brand.id,
                                 updated_at: 1.day.ago)
    @brand.increment_homepage_counter
    counter.reload

    expect(counter.value).to eq(1)
  end

  describe ".faq_categories_with_faqs" do
    it "should include only faq categories that aren't empty" do
      faq_category = FactoryBot.create(:faq_category, brand: @brand)
      faq_category.faqs << FactoryBot.create(:faq)
      empty_category = FactoryBot.create(:faq_category, brand: @brand)

      expect(@brand.faq_categories_with_faqs).to include(faq_category)
      expect(@brand.faq_categories_with_faqs).not_to include(empty_category)
    end
  end

  describe "support email recipient" do
    it "should use 'support_email' setting" do
      FactoryBot.create(:setting, name: 'support_email', string_value: 'jose@support.com', brand_id: @brand.id)

      expect(@brand.support_email).to eq('jose@support.com')
    end
  end

  describe "parts email recipient" do
    it "should use 'parts_email' setting" do
      FactoryBot.create(:setting, name: 'parts_email', string_value: 'larry@support.com', brand_id: @brand.id)

      expect(@brand.parts_email).to eq('larry@support.com')
    end
  end

  describe "rma email recipient" do
    it "should use 'rma_email' setting" do
      FactoryBot.create(:setting, name: 'rma_email', string_value: 'ramesh@support.com', brand_id: @brand.id)

      expect(@brand.rma_email).to eq('ramesh@support.com')
    end
  end

  describe "looking up setting" do
    before do
      @locale_setting = FactoryBot.create(:setting, brand: @brand, locale: "en-US", setting_type: "string", string_value: "foo123", name: "setting1")
      @parent_setting = FactoryBot.create(:setting, brand: @brand, locale: "en", setting_type: "string", string_value: "foo456", name: "setting1")
      @setting_for_nil_locale = FactoryBot.create(:setting, brand: @brand, locale: nil, setting_type: "string", string_value: "foo789", name: "setting1")
      @setting_for_blank_locale = FactoryBot.create(:setting, brand: @brand, locale: "", setting_type: "string", string_value: "foo789", name: "setting1")
    end

    after :all do
      I18n.locale = I18n.default_locale
    end

    it "should find the locale-specific setting" do
      I18n.locale = "en-US"
      expect(@brand.setting1).to eq(@locale_setting.string_value)
    end

    it "should revert to the parent locale if present" do
      I18n.locale = "en"
      expect(@brand.setting1).to eq(@parent_setting.string_value)
    end

    it "should use the default (nil) locale" do
      I18n.locale = "zh"
      expect(@brand.setting1).to eq(@setting_for_nil_locale.string_value)
    end

    it "should use the default (blank) locale" do
      I18n.locale = "zh"
      expect(@brand.setting1).to eq(@setting_for_blank_locale.string_value)
    end
  end
end
