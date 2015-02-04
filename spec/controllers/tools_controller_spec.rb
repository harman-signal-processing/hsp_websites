require 'rails_helper'

RSpec.describe ToolsController, :type => :controller do

  describe "GET calculators" do
    it "returns http success" do
      get :calculators
      expect(response).to have_http_status(:success)
    end
  end

end
