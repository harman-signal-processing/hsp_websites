require "rails_helper"

RSpec.describe TrainingModulesHelper do

  describe "show_module" do
    it "shows swf module inline" do
      tm = FactoryGirl.build_stubbed(:training_module, training_module_file_name: 'test.swf')

      content = helper.show_module(tm)

      expect(content).to eq (swf_tag(tm.training_module.url, size: "#{tm.width}x#{tm.height}"))
    end

    it "shows a link to download mov modules" do
      tm = FactoryGirl.build_stubbed(:training_module, training_module_file_name: 'test.mov')

      content = helper.show_module(tm)

      expect(content).to eq(link_to("Download Quicktime Movie", tm.training_module.url('original', false)))
    end

    it "shows other videos inline" do
      tm = FactoryGirl.build_stubbed(:training_module, training_module_file_name: 'test.mp4')
      expect(helper).to receive(:website).and_return(FactoryGirl.build_stubbed(:website))

      content = helper.show_module(tm)

      expect(content).to match(/Loading the player/)
    end
  end
end
