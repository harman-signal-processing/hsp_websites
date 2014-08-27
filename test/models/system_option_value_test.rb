require "test_helper"

describe SystemOptionValue do
  let(:system_option_value) { SystemOptionValue.new }

  it "must be valid" do
    system_option_value.must_be :valid?
  end
end
