require 'rails_helper'

RSpec.describe "admin/vip_programmers/index", type: :view do
  before :all do
  	@vip_programmer = FactoryBot.create(:vip_programmer)
  end
  
  before :each do
  	assign(:vip_programmers, [@vip_programmer])
  	render
  end  
  
  it "Vip::Programmer Admin index should list vip programmers" do
    expect(rendered).to have_link('Edit', href: edit_admin_vip_programmer_path(@vip_programmer))
  end  
  
end
