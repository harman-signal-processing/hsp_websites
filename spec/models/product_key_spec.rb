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

  describe "checking stock levels" do
    include ActiveJob::TestHelper

    it "should trigger low-stock notifications" do
      product_key = FactoryBot.create(:product_key, line_item_id: nil)
      subscription = FactoryBot.create(:product_stock_subscription, product: product_key.product, low_stock_level: 1)

      perform_enqueued_jobs do
        product_key.update(line_item_id: 123)
      end

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to[0]).to eq(subscription.user.email)
    end
  end
end
