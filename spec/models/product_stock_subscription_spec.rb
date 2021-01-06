require 'rails_helper'

RSpec.describe ProductStockSubscription, type: :model do
  before(:all) do
    @product_stock_subscription = FactoryBot.build_stubbed(:product_stock_subscription)
  end

  subject { @product_stock_subscription }
  it { should respond_to(:user) }
  it { should respond_to(:product) }
  it { should respond_to(:low_stock_level) }
end
