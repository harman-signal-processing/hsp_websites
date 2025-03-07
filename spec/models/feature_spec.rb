require 'rails_helper'

RSpec.describe Feature, type: :model do

  it "should respond to name" do
    pf = create(:product_family)
    feature = FactoryBot.build(:feature, featurable: pf)

    expect(feature).to respond_to :name
  end

  describe "for ProductFamilies" do
    before do
      @product_family = FactoryBot.create(:product_family)
      @feature = FactoryBot.build(:feature)
    end

    it "should associate" do
      @product_family.features << @feature

      @product_family.reload
      expect(@product_family.features).to include(@feature)
    end

    it "should generate a name" do
      @product_family.features << @feature

      @feature.reload
      expect(@feature.name).to match(/#{@product_family.name}/i)
    end

    it "should update the product family timestamp" do
      product_family = FactoryBot.create(:product_family, updated_at: 1.day.ago)
      timestamp = product_family.updated_at
      product_family.features << @feature
      product_family.reload

      expect(product_family.updated_at).not_to eq(timestamp)
    end
  end
end
