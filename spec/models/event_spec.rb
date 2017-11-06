require 'rails_helper'

RSpec.describe Event, type: :model do

  before do
    @event = FactoryBot.create(:event)
  end

  subject { @event }
  it { should respond_to :brand }
  it { should respond_to :image }
  it { should respond_to :friendly_id }

  it "should return all for a given website" do
    afw = Event.all_for_website(@event.brand)

    expect(afw).to include(@event)
  end
end
