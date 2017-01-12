require "rails_helper"

RSpec.describe ContentTranslation do

  describe "#translatables" do
    it "looks up things that can be translated for the brand" do
      brand = FactoryGirl.build_stubbed(:brand)

      t = ContentTranslation.translatables(brand)

      expect(t.keys).to include("product")
      expect(t.keys).to include("product_family")
      expect(t.keys).to include("specification")
      expect(t.keys).to include("news")
      expect(t.keys).to include("page")
      expect(t.keys).to include("promotion")
    end

    it "includes effects if the brand has them" do
      brand = FactoryGirl.build_stubbed(:brand, has_effects: true)

      t = ContentTranslation.translatables(brand)

      expect(t.keys).to include("effect")
      expect(t.keys).to include("effect_type")
      expect(t.keys).to include("amp_model")
      expect(t.keys).to include("cabinet")
    end

    it "includes product_reviews if the brand has reviews" do
      brand = FactoryGirl.build_stubbed(:brand, has_reviews: true)

      t = ContentTranslation.translatables(brand)

      expect(t.keys).to include("product_review")
    end

    it "includes artists if the brand has artists" do
      brand = FactoryGirl.build_stubbed(:brand, has_artists: true)

      t = ContentTranslation.translatables(brand)

      expect(t.keys).to include("artist")
    end

    it "includes faqs if the brand has them" do
      brand = FactoryGirl.build_stubbed(:brand, has_faqs: true)

      t = ContentTranslation.translatables(brand)

      expect(t.keys).to include("faq")
    end

    it "includes market segments if the brand has them" do
      brand = FactoryGirl.build_stubbed(:brand, has_market_segments: true)

      t = ContentTranslation.translatables(brand)

      expect(t.keys).to include("market_segment")
    end
  end

  describe "fields to translate for" do
    it "includes the fields from #translatables" do
      brand = FactoryGirl.build_stubbed(:brand)
      product = FactoryGirl.build_stubbed(:product, brand: brand)

      f = ContentTranslation.fields_to_translate_for(product, brand)

      expect(f).to include("name")
      expect(f).to include("short_description")
    end
  end

  describe "translate text content" do
    it "looks up the translation from a parent locale" do
      product = FactoryGirl.create(:product)
      ct = FactoryGirl.build(:content_translation,
                         content_type: "Product",
                         content_method: "name",
                         content_id: product.id,
                         locale: "es")

      # For some reason this field can't be set by factory girl
      ct.content = "MX99"
      ct.save

      allow(I18n).to receive(:locale).and_return("es-MX")
      c = ContentTranslation.translate_text_content(product, :name)

      expect(c).to eq ct.content
    end

    it "looks up the translation from an exact locale" do
      product = FactoryGirl.create(:product)
      ct = FactoryGirl.build(:content_translation,
                         content_type: "Product",
                         content_method: "name",
                         content_id: product.id,
                         locale: "es-MX")

      ct.content = "SP99"
      ct.save

      allow(I18n).to receive(:locale).and_return("es-MX")
      c = ContentTranslation.translate_text_content(product, :name)

      expect(c).to eq ct.content
    end

    it "looks up the translation from a sister locale" do
      product = FactoryGirl.create(:product)
      ct = FactoryGirl.build(:content_translation,
                         content_type: "Product",
                         content_method: "name",
                         content_id: product.id,
                         locale: "es-XX")

      ct.content = "XX99"
      ct.save

      allow(I18n).to receive(:locale).and_return("es-MX")
      c = ContentTranslation.translate_text_content(product, :name)

      expect(c).to eq ct.content
    end
  end
end
