class AdminController < ApplicationController
  skip_before_action :verify_authenticity_token, :ensure_locale_for_site, raise: false
  before_action :store_user_location!, if: :storable_location?
  before_action :set_locale
  # before_action :require_admin_authentication
  before_action :authenticate_user!
  check_authorization
  skip_authorization_check only: [:index]
  layout 'admin'

  def index
    @msg = ""
    unless can?(:manage, :all) || can?(:manage, ContentTranslation) || can?(:manage, Product) ||
      can?(:manage, Software) || can?(:manage, ServiceCenter) || can?(:manage, Artist) ||
      can?(:manage, Setting) || can?(:manage, Dealer)
      if can?(:read, OnlineRetailer)
        redirect_to admin_online_retailers_path and return
      elsif current_user.end_user_only?
        redirect_to root_path and return
      else
        @msg = "You don't appear to have access to any resources. Please contact adam.anderson@harman.com or darryl.dalton@harman.com."
      end
    end
    @orl_problems = OnlineRetailerLink.problems
    render_template
  end

  # Overrides the same method in ApplicationController so that we use the same admin pages
  # for all sites.
  def render_template(options={})
    default_options = {controller: controller_path, action: action_name, layout: "admin"}
    options = default_options.merge options
    render template: "#{options[:controller]}/#{options[:action]}", layout: options[:layout]
  end

  private

  # Always operate admin in default locale
  def set_locale
    I18n.locale = I18n.default_locale
  end

end
