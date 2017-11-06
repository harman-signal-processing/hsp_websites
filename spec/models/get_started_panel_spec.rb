require 'rails_helper'

RSpec.describe GetStartedPanel, type: :model do

  before do
    @get_started_panel = FactoryBot.build_stubbed(:get_started_panel)
  end

  subject { @get_started_panel }
  it { should respond_to :get_started_page }
  it { should respond_to :name }
  it { should respond_to :locked_until_registration }
end
