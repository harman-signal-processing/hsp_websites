class ToolkitController < ApplicationController
  layout "toolkit"
  before_action :authenticate_toolkit_user!

  def index
  end

end
