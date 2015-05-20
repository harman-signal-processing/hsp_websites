module Api
  module V2
    class SoftwaresController < ApplicationController
      skip_before_filter :miniprofiler
      respond_to :xml

      def index
        @brand = Brand.find(params[:brand_id])
        @softwares = @brand.current_softwares
        respond_with @softwares
      end

      def show
        @software = Software.find(params[:id])
        respond_with @software
      end

    end
  end
end
