require "rails_helper"

RSpec.describe ContactMessage, :type => :model do
  before do
    @brand = FactoryBot.create(:brand)
    @contact_message = FactoryBot.build(:contact_message, brand: @brand)
  end

  subject { @contact_message }
  it { should respond_to :brand }

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
      support_subject = FactoryBot.create(:support_subject, brand_id: @brand.id)

      subjects = ContactMessage.subjects(brand: @brand)
      expect(subjects).to be_an(Array)
      expect(subjects.first).to be_an(Array)
      expect(subjects.first).to include(support_subject.name)
    end

    it "loads translated brand-specific subjects" do
      english_subject = FactoryBot.create(:support_subject, brand_id: @brand.id)
      chinese_subject = FactoryBot.create(:support_subject, brand_id: @brand.id, locale: "zh")

      subjects = ContactMessage.subjects(brand: @brand, locale: "zh-CN")
      expect(subjects.flatten).to include(chinese_subject.name)
      expect(subjects.flatten).not_to include(english_subject.name)
    end
  end

  describe "country recipients" do

    it "sends to the distributor if there is exactly one for the country" do
      distributor = FactoryBot.create(:distributor)
      brand = FactoryBot.create(:brand, send_contact_form_to_distributors: true)
      brand.distributors << distributor
      contact_message = FactoryBot.build_stubbed(:contact_message,
        shipping_country: distributor.country,
        brand: brand)

      expect(contact_message.recipients).to include(distributor.email)
    end

    it "sends to the brand default if there is more than one distributor for the country" do
      distributor = FactoryBot.create(:distributor)
      distributor2 = FactoryBot.create(:distributor, country: distributor.country)
      brand = FactoryBot.build(:brand, send_contact_form_to_distributors: true)
      brand.distributors << distributor
      brand.distributors << distributor2
      contact_message = FactoryBot.build(:contact_message,
        shipping_country: distributor.country,
        brand: brand)

      expect(contact_message.recipients).not_to include(distributor.email)
      expect(contact_message.recipients).to include(brand.support_email)
    end

    it "sends to the brand default if the brand is not configured to send to distributors" do
      distributor = FactoryBot.create(:distributor)
      brand = FactoryBot.build(:brand, send_contact_form_to_distributors: false)
      brand.distributors << distributor
      contact_message = FactoryBot.build_stubbed(:contact_message,
        shipping_country: distributor.country,
        brand: brand)

      expect(contact_message.recipients).not_to include(distributor.email)
      expect(contact_message.recipients).to include(brand.support_email)
    end

    it "sends to the brand default if the distributor's email is blank" do
      distributor = FactoryBot.create(:distributor, email: nil)
      brand = FactoryBot.build(:brand, send_contact_form_to_distributors: true)
      brand.distributors << distributor
      contact_message = FactoryBot.build_stubbed(:contact_message,
        shipping_country: distributor.country,
        brand: brand)

      expect(contact_message.recipients).to include(brand.support_email)
    end
  end

  describe "Regional recipients" do
    it "sends to the corresponding support email for the country's region" do
      country = "Fooberland"
      brand = FactoryBot.create(:brand, send_contact_form_to_regional_support: true)
      sales_region = FactoryBot.create(:sales_region, brand: brand)
      sales_region.sales_region_countries << FactoryBot.build(:sales_region_country, name: country)

      contact_message = FactoryBot.build_stubbed(:contact_message,
                                                 shipping_country: country,
                                                 brand: brand)

      expect(contact_message.recipients).to include(sales_region.support_email)
    end

    it "sends to the default recipient when no matching region is found" do
      country = "Fooberland"
      brand = FactoryBot.create(:brand, send_contact_form_to_regional_support: true)
      sales_region = FactoryBot.create(:sales_region, brand: brand)
      sales_region.sales_region_countries << FactoryBot.build(:sales_region_country, name: country)

      contact_message = FactoryBot.build_stubbed(:contact_message,
                                                 shipping_country: "SomethingElse",
                                                 brand: brand)

      expect(contact_message.recipients).not_to include(sales_region.support_email)
      expect(contact_message.recipients).to include(brand.support_email)
    end

  end

  describe "RMA" do
    it "sends to the brand's repair email" do
      contact_message = FactoryBot.build_stubbed(:contact_message, message_type: "repair_request")

      expect(contact_message.recipients).to include(contact_message.brand.rma_email)
    end
  end

  describe "RMA credit return request" do
    it "sends to the brand's rma_credit_email" do
      contact_message = FactoryBot.build_stubbed(:contact_message, message_type: "rma_credit_request")

      expect(contact_message.recipients).to include(contact_message.brand.rma_credit_email)
    end
  end  

  describe "RMA repair return request" do
    it "sends to the brand's rma_repair_email" do
      contact_message = FactoryBot.build_stubbed(:contact_message, message_type: "rma_repair_request")

      expect(contact_message.recipients).to include(contact_message.brand.rma_repair_email)
    end
  end 

  describe "Parts request" do
    it "sends to the brand's parts email" do
      contact_message = FactoryBot.build_stubbed(:contact_message, message_type: "part_request")

      expect(contact_message.recipients).to include(contact_message.brand.parts_email)
    end
  end

end
