class ToolkitController < ApplicationController
  layout "toolkit"
  skip_before_action :miniprofiler
  before_action :authenticate_toolkit_user!

  def index
  end

end
