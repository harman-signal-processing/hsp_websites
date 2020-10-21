require "rails_helper"

RSpec.describe News, :type => :model do

  before do
    @news = FactoryBot.build_stubbed(:news)
  end

  subject { @news }
  it { should respond_to(:title) }
  it { should respond_to(:brands) }
  it { should respond_to(:quote) }

end
