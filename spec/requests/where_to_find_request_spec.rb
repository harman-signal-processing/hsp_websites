require 'rails_helper'

RSpec.describe "WhereToFinds", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/where_to_find/index"
      expect(response).to have_http_status(:success)
    end
  end

end
