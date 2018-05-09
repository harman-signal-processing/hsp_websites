class ToolkitController < ApplicationController
  layout "toolkit"
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_toolkit_user!

  def index
  end

end
