# Note: v2 of the api is open to all without restriction and is a basic product catalog

module Api
  module V2
    class BrandsController < ApplicationController
      respond_to :xml, :json, :html

      # Only active brands, plus AKG for Consultant portal page on HPro site
      # This removes former Harman brands
      def index
        @brands = Brand.where(live_on_this_platform: true).or(Brand.where(name: "AKG"))
        respond_with @brands
      end

      def show
        @brand = Brand.find(params[:id])
        respond_with @brand
      end

    end
  end
end
