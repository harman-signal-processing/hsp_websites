class ManufacturerPartnersController < ApplicationController
    def index
        @partners = ManufacturerPartner.all.order(:name)
    end
end
