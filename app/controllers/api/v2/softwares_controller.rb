# Note: v2 of the api is open to all without restriction and is a basic product catalog

module Api
  module V2
    class SoftwaresController < ApplicationController
      skip_before_action :miniprofiler
      before_action :set_brand
      respond_to :xml, :json, :html

      def index
        @softwares = @brand.current_softwares
        respond_with @softwares
      end

      def show
        @software = Software.find(params[:id])
        if @software.active?
          respond_with @software
        else
          respond_with Software.new
        end
      end

      private

      def set_brand
        @brand = Brand.find(params[:brand_id])
      end

    end
  end
end
