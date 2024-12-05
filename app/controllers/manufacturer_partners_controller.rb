class ManufacturerPartnersController < ApplicationController
    respond_to :html
    respond_to :js, only: :featured_partners

    def index
        # @partners = ManufacturerPartner.all.order(:name)
        @partners = ManufacturerPartner.all.order("RAND()")
    end
    def partners_inconcert

        # Loads variables to drive featured partners slides
        featured_partners

        @sort_param = params[:sort]
        if @sort_param == "alpha"
            @partners = ManufacturerPartner.all.order(:name)
        else
            @partners = ManufacturerPartner.all.order("RAND()")
        end
    end

    def partners_home
        @page = Page.where(custom_route: "amx-partners-program").first
        render template: "/pages/show"
    end

    def featured_partner
        partner_name = params[:partner_name]
        # @page = Page.where(custom_route: "amx-partners-featured").first
        if partner_name.present? && Page.exists?(custom_route: "amx-partners-featured-#{partner_name}")
            @page = Page.where(custom_route: "amx-partners-featured-#{partner_name}").first
            render template: "/pages/show"
        else
            @page = Page.where("custom_route like 'amx-partners-featured-%'").order("RAND()").first
            @page.custom_route.match(/amx-partners-featured-(.*)/)
            redirect_to amx_featured_partner_selected_path(partner_name: $1) and return false
        end
    end

    def featured_partners
        @featured_partners = Page.where("custom_route like 'amx-partners-featured-%'").order("RAND()").limit(5)
        @partners_for_slides = []
        @featured_partners.each do |p|
            partner_name = p.custom_route.gsub("amx-partners-featured-","")
            banner_image_url = get_banner_image_url(partner_name)
            if banner_image_url.present?
                item = {}
                item[:id] = p.id
                item[:image_url] = banner_image_url
                item[:title] = p.title
                item[:custom_route] = p.custom_route
                item[:cached_slug] = p.cached_slug
                item[:created_at] = p.created_at
                item[:updated_at] = p.updated_at
                item[:url] = "https://www.amx.com/partners/featured/#{partner_name}"
              @partners_for_slides << item
            end  #  if banner_image_url.present?
        end  #  @featured_partners.each do |p|


	    respond_to do |format|
	      format.html { @partners_for_slides }
	      format.json  { render json: @partners_for_slides }
	    end	 #  respond_to do |format|

    end  #  def featured_partners

    private

    def get_banner_image_url(partner_name)
        banner_image_url = ""
        banner_image_url_png = "https://www.amx.com/resource/amx-partner-programs-featured-partner-banner-#{partner_name}.png"
        banner_image_url_jpg = "https://www.amx.com/resource/amx-partner-programs-featured-partner-banner-#{partner_name}.jpg"

        png_banner_exists = banner_image_exists(banner_image_url_png)
        if png_banner_exists
            banner_image_url = banner_image_url_png
        else
            jpg_banner_exists = banner_image_exists(banner_image_url_jpg)
            banner_image_url = banner_image_url_jpg if jpg_banner_exists
        end
        banner_image_url
    end  #  def get_banner_image_url

    def banner_image_exists(banner_image_url)
        begin
            file_exists = RestClient.head(banner_image_url).code == 200
        rescue #RestClient::Exception => error
            file_exists = false
        end
        file_exists
    end  #  banner_image_exists(url)
end  #  class ManufacturerPartnersController < ApplicationController
