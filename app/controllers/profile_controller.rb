class ProfileController < ApplicationController
  before_action :set_locale
  before_action :authenticate_user!

  def show
  end
end
