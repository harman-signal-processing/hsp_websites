class PagesController < ApplicationController
  before_action :set_locale_for_pages
  before_action :load_and_authorize_page, only: :show
  skip_before_action :verify_authenticity_token

  # GET /pages
  # GET /pages.xml
  def index
    redirect_to root_path
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    respond_to do |format|
      format.html {
        @hreflangs = @page.hreflangs(website)

        if !@page.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "pages", "#{@page.layout_class}.html.erb"))
          render template: "#{website.folder}/pages/#{@page.layout_class}", layout: set_layout
        else
          render_template(action: 'show')
        end
      }
      format.xml  { render xml: @page }
    end
  end

  # Using CMS page "network-audio" if present as of 08/2017
  # /network-audio replacing old BSS/Crown solutions page 11/2016
  # /solutions Added for BSS,Crown 6/2015
  def network_audio
    if Page.exists?(custom_route: "network-audio-#{website.brand.name.to_param.downcase}")
      @page = Page.where(custom_route: "network-audio-#{website.brand.name.to_param.downcase}").first
      show and return false
    elsif Page.exists?(custom_route: "network-audio")
      @page = Page.where(custom_route: "network-audio").first
      show and return false
    else
      @hide_main_container = true
      render_template
    end
  end

  private

  def load_and_authorize_page
    if params[:id]
      @page = Page.find(params[:id])
    elsif params[:custom_route]
      @page = Page.where(custom_route: params[:custom_route], brand_id: website.brand_id).first
    end
    unless @page
      @registered_download = RegisteredDownload.where(url: params[:custom_route], brand_id: website.brand_id).first!
      redirect_to register_to_download_path(@registered_download.url, params[:code]) and return
    else
      raise ActiveRecord::RecordNotFound unless website.pages.pluck(:id).include?(@page.id)
      if @page.requires_login?
        authenticate_or_request_with_http_basic("#{@page.title} - Protected") do |user, password|
          user == @page.username && password == @page.password
        end
      end
    end
  end

  # In order to allow routes like /cool_page (without the locale), we
  # loosely check the locale for pages--meaning we don't redirect to the
  # homepage if we don't find a locale...we just use the default.
  def set_locale_for_pages
    # This is where we set the locale:
    if params[:locale]
      I18n.locale = params[:locale]
    else
      begin
        I18n.locale = website.locale
      rescue
        # If we're here, then there was no 'website' associated with the http request
        # that probably means someone is trying something tricky, so, just show them
        # a generic page not found page:
        raise ActiveRecord::RecordNotFound
      end
    end
  end

end
