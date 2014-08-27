require "test_helper"

describe SystemOption do
  let(:system_option) { SystemOption.new }

  it "must be valid" do
    system_option.must_be :valid?
  end
end
