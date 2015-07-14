require "rails_helper"

RSpec.describe SiteMailer, type: :mailer do

	before :all do
		@website = FactoryGirl.create(:website_with_products)
    @brand = @website.brand
    @contact_message = FactoryGirl.build(:contact_message)
	end

	describe "contact form" do
    before do
      allow(@brand).to receive(:support_email).and_return('support@harman.com')
    end

    let(:mail) { SiteMailer.contact_form(@contact_message, @website) }

		it "should have the selected subject" do
			expect(mail.subject).to eq @contact_message.subject
		end

		it "should come from the person completing the form" do
			expect(mail.from).to eq [@contact_message.email]
		end

		it "should go to the brand's support_email" do
			expect(mail.to).to eq ["support@harman.com"] # (from the 'setting')
		end

		it "should have the form information" do
			expect(mail.body.encoded).to match @contact_message.name
			expect(mail.body.encoded).to match @contact_message.email
			expect(mail.body.encoded).to match @contact_message.product
			expect(mail.body.encoded).to match @contact_message.product_serial_number
			expect(mail.body.encoded).to match @contact_message.operating_system
			expect(mail.body.encoded).to match @contact_message.shipping_address
			expect(mail.body.encoded).to match @contact_message.shipping_country
			expect(mail.body.encoded).to match @contact_message.phone
			expect(mail.body.encoded).to match @contact_message.message
		end

	end

end
