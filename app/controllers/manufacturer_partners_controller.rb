class ManufacturerPartnersController < ApplicationController
    def index
        # @partners = ManufacturerPartner.all.order(:name)
        @partners = ManufacturerPartner.all.order("RAND()")
    end
    def partners_inconcert
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
        @page = Page.where(custom_route: "amx-partners-featured").first
        render template: "/pages/show"
    end

end  #  class ManufacturerPartnersController < ApplicationController
