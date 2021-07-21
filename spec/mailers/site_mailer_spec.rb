require "rails_helper"

RSpec.describe SiteMailer, type: :mailer do

	before :all do
		@website = create(:website)
    @brand = @website.brand
    @contact_message = build(:contact_message, brand: @brand)
	end

	describe "contact form" do
    before do
      allow(@brand).to receive(:support_email).and_return('support@brand.com')
    end

    let(:mail) { SiteMailer.contact_form(@contact_message, @website) }

		it "should have the selected subject" do
			expect(mail.subject).to eq @contact_message.subject
		end

		it "should go to the brand's support_email" do
			expect(mail.to).to include "support@brand.com" # (from the 'setting')
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
