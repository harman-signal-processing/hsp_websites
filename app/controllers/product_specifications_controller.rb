class ProductSpecificationsController < ApplicationController
  before_action :set_locale
  load_and_authorize_resource

  def edit
    @return_to = request.referer
  end

end
