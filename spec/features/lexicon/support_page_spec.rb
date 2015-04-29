require "rails_helper"

feature "Lexicon support page" do

  before :all do
    @brand = FactoryGirl.create(:lexicon_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "lexicon", brand: @brand)
    @product = @website.products.first
    @software = FactoryGirl.create(:software, brand: @brand)
    @product.product_softwares << FactoryGirl.create(:product_software, software: @software, product: @product)
    @product.save
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  before :each do
    allow_any_instance_of(Brand).to receive(:main_tabs).and_return("description|extended_description|features|specifications|reviews|downloads_and_docs")

    visit support_path
  end

  it "should require the country on the contact form" do
    message_count = ContactMessage.count
    expect(page).to have_content "Country (required)"
    select ContactMessage.subjects.last[0], from: "contact_message_subject"
    fill_in "contact_message_name", with: "Joe"
    fill_in "contact_message_email", with: "joe@joe.com"
    fill_in "contact_message_message", with: "Hi Dean. How are you?"
    click_on("submit")

    expect(page).to have_content("Country can't be blank")
    expect(ContactMessage.count).to eq(message_count)
  end

  it "should redirect to the downloads tab of a current product" do
    select @product.name, from: 'product_id'
    click_on "go"

    expect(page).to have_css("li#downloads_and_docs_tab.current")
  end

end
