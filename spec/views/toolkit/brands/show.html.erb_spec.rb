require "rails_helper.rb"

RSpec.describe "toolkit/brands/show.html.erb", as: :view do

  before :all do
    @brand = FactoryBot.create(:brand, toolkit: true)
    @marketing_message = FactoryBot.build_stubbed(:toolkit_resource, brand: @brand, message: "This is great.")
    assign(:brand, @brand)
    assign(:marketing_messages, [@marketing_message])
  end

  before :each do
    render
  end

  it "should show marketing messages" do
    expect(rendered).to have_content(@marketing_message.message)
  end

end
