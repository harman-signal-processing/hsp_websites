require "rails_helper"

RSpec.describe TrainingModulesHelper do

  describe "show_module" do

    it "shows a link to download mov modules" do
      tm = FactoryBot.build_stubbed(:training_module, training_module_file_name: 'test.mov')

      content = helper.show_module(tm)

      expect(content).to eq(link_to("Download Quicktime Movie", tm.training_module.url('original', false)))
    end

  end

end
