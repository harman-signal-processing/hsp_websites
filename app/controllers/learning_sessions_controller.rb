class LearningSessionsController < ApplicationController
  before_action :set_locale
  
  def index
    @learning_sessions = LearningSessionService.get_learning_session_data(website.brand.name.downcase)
  end  #  def index
  
end  #  class LearningSessionsController < ApplicationController