require 'rails_helper'

RSpec.describe Badge, type: :model do

  before do
    @badge = FactoryBot.create(:badge)
  end

  subject { @badge }
  it { should respond_to :name }
  it { should respond_to :image }
  it { should respond_to :products }
end
