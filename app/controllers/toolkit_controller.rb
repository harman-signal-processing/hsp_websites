class ToolkitController < ApplicationController
  layout "toolkit"
  skip_before_filter :miniprofiler
  before_filter :authenticate_toolkit_user!
  
  def index
  end

end
