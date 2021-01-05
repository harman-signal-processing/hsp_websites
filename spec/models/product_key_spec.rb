require 'rails_helper'

RSpec.describe ProductKey, type: :model do

  before do
    @product_key = FactoryBot.build_stubbed(:product_key)
  end

  subject { @product_key }
  it { should respond_to(:key) }
  it { should respond_to(:product) }
  it { should respond_to(:user) }
  it { should respond_to(:line_item) }
  it { should respond_to(:sales_order) }
end
