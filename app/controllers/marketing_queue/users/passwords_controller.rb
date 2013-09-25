class MarketingQueue::Users::PasswordsController < Devise::PasswordsController
	layout 'marketing_queue'
	before_filter :build_search

	private

  def build_search
    @q = MarketingProject.ransack(params[:q])
  end
end