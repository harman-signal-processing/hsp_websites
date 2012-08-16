class AdminController < ApplicationController
  skip_before_filter :set_default_meta_tags, :verify_authenticity_token, :set_locale
  # before_filter :require_admin_authentication
  before_filter :authenticate_user!
  check_authorization
  skip_authorization_check only: [:index]
  layout 'admin'
  
  def index
    @msg = ""
    unless can?(:manage, :all) || can?(:manage, ContentTranslation) || can?(:manage, Product) ||
      can?(:manage, Software) || can?(:manage, ServiceCenter) || can?(:manage, Artist) ||
      can?(:manage, Setting) || can?(:read, Clinic)
      if can?(:read, OnlineRetailer)
        redirect_to admin_online_retailers_path and return
      else
        @msg = "You don't appear to have access to any resources. Please contact adam.anderson@harman.com."
      end
    end
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

  def expire_product_families_cache
    ALL_LOCALES.each do |locale|
      expire_page(controller: "product_families", action: "index", locale: locale)
    end
    expire_fragment("homepage_features_#{website.brand_id}")
  end
  
  def expire_software_index_cache
    ALL_LOCALES.each do |locale|
      expire_page(controller: "softwares", action: "index", locale: locale)
    end
  end
  
  def expire_news_index_cache
    ALL_LOCALES.each do |locale|
      expire_page(controller: "news", action: "index", locale: locale)
    end
  end

end
