class NodeTestController < ApplicationController
  layout "nodetest"

  # All we're testing here is that the rails app is running
  def index
    Rails.logger.silence do
      render
    end
  end

end
