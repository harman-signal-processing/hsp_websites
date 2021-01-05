class SalesOrdersController < ApplicationController
  before_action :set_locale
  load_and_authorize_resource only: :show

  def show
  end

end
