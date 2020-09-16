class ManufacturerPartnersController < ApplicationController
    def index
        # @partners = ManufacturerPartner.all.order(:name)
        @partners = ManufacturerPartner.all.order("RAND()")
    end
end
