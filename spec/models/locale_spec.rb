require 'rails_helper'

RSpec.describe Locale, type: :model do

  before :all do
    @locale = FactoryBot.create(:locale)
  end

  subject { @locale }
  it { should respond_to :name }
  it { should respond_to :code }

  describe "primaries" do
    before do
      @primary_locale = FactoryBot.create(:locale, code: "zz")
    end

    it "should identify as a primary" do
      expect(@primary_locale.is_primary?).to be(true)
      expect(Locale.primaries).to include(@primary_locale)
    end

    it "should find its regionals" do
      regional_locale = FactoryBot.create(:locale, code: "zz-QQ")

      expect(@primary_locale.regionals).to include(regional_locale)
    end

    it "should return its own code as the language code" do
      expect(@primary_locale.language_code).to eq(@primary_locale.code)
    end

    it "should not have a regional code" do
      expect(@primary_locale.regional_code).to be(nil)
    end
  end

  describe "regionals" do
    before do
      @primary_locale = FactoryBot.create(:locale, code: "rr")
      @regional_locale = FactoryBot.create(:locale, code: "rr-ZZ")
    end

    it "should not appear in the set of primaries" do
      expect(Locale.primaries).not_to include(@regional_locale)
    end

    it "should identify as a regional" do
      expect(@regional_locale.is_regional?).to be(true)
    end

    it "should find its related primary" do
      expect(@regional_locale.primary).to eq(@primary_locale)
    end

    it "should have a language code which equals its parent code" do
      expect(@regional_locale.language_code).to eq(@primary_locale.code)
    end

    it "should have a regional code" do
      expect(@regional_locale.regional_code).to eq("ZZ")
    end
  end

  describe "website locales" do
    before do
      @website_locale = FactoryBot.create(:website_locale, locale: @locale.code)
    end

    it "should find its related website_locales" do
      expect(@locale.website_locales).to include(@website_locale)
    end

    it "should pick up the name from the locale" do
      expect(@website_locale.name).to eq(@locale.name)
    end
  end

end
