require "rails_helper"

RSpec.describe ContactMessage, :type => :model do
  before do
    @brand = FactoryGirl.create(:brand)
    @contact_message = FactoryGirl.build(:contact_message)
  end

  describe "#subjects" do

    it "has defaults" do
      subjects = ContactMessage.subjects

      expect(subjects).to be_an(Array)
      expect(subjects.flatten).to include(I18n.t('subjects.product_question'))
    end

    it "loads defaults when brand is provided but no custom subjects exist" do
      subjects = ContactMessage.subjects(brand: @brand)

      expect(subjects.flatten).to include(I18n.t('subjects.product_question'))
    end

    it "loads brand-specific subjects when provided" do
      support_subject = FactoryGirl.create(:support_subject, brand_id: @brand.id)

      subjects = ContactMessage.subjects(brand: @brand)
      expect(subjects).to be_an(Array)
      expect(subjects.first).to be_an(Array)
      expect(subjects.first).to include(support_subject.name)
    end

    it "loads translated brand-specific subjects" do
      english_subject = FactoryGirl.create(:support_subject, brand_id: @brand.id)
      chinese_subject = FactoryGirl.create(:support_subject, brand_id: @brand.id, locale: "zh")

      subjects = ContactMessage.subjects(brand: @brand, locale: "zh-CN")
      expect(subjects.flatten).to include(chinese_subject.name)
      expect(subjects.flatten).not_to include(english_subject.name)
    end
  end
end
