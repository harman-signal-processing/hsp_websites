# Note: v2 of the api is open to all without restriction and is a basic product catalog

module Api
  module V2
    class BrandsController < ApplicationController
      skip_before_filter :miniprofiler
      respond_to :xml, :json, :html

      def index
        @brands = Brand.all
        respond_with @brands
      end

      def show
        @brand = Brand.find(params[:id])
        respond_with @brand
      end

    end
  end
end
