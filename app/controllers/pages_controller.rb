class PagesController < ApplicationController
  before_filter :set_locale_for_pages
  before_filter :load_and_authorize_page, only: :show
  skip_before_filter :verify_authenticity_token
    
  # GET /pages
  # GET /pages.xml
  def index
    redirect_to root_path
    # @pages = Page.all
    # 
    # respond_to do |format|
    #   format.html { render_template } # index.html.erb
    #   format.xml  { render xml: @pages }
    # end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    respond_to do |format|
      format.html { 
        if !@page.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "pages", "#{@page.layout_class}.html.erb"))
          render template: "#{website.folder}/pages/#{@page.layout_class}", layout: set_layout
        else
          render_template
        end
      }
      format.xml  { render xml: @page }
    end
  end
  
  private
  
  def load_and_authorize_page
    if params[:id]
      @page = Page.find(params[:id])
    elsif params[:custom_route]
      @page = Page.where(custom_route: params[:custom_route]).first
    end
    unless @page 
      @registered_download = RegisteredDownload.where(url: params[:custom_route], brand_id: website.brand_id).first
      if @registered_download
        redirect_to register_to_download_path(@registered_download.url, params[:code]) and return
      else
        error_page(404)
      end
    else
      if !website.pages.include?(@page)
        error_page(404)
      else
        if @page.requires_login?
          authenticate_or_request_with_http_basic("#{@page.title} - Protected") do |user, password|
            user == @page.username && password == @page.password
          end
        end
        # Causing a double-render error:
        # unless @page.friendly_id_status.best?
        #   redirect_to @page, status: :moved_permanently and return
        # end
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
        render template: "errors/404", layout: false, status: '404' and return
      end
    end
  end

end
