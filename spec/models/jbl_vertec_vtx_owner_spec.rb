require 'rails_helper'

RSpec.describe JblVertecVtxOwner, type: :model do
  before do
    @owner = FactoryBot.create(:jbl_vertec_vtx_owner)
  end
  
  it 'should pass all valididations' do
    expect(@owner).to be_valid
  end
end
