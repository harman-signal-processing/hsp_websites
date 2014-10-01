class SystemsController < ApplicationController
	http_basic_authenticate_with name: "idx", password: "idx"
	protect_from_forgery except: :show
	load_resource
	respond_to :html, :js

	def index
		@systems = System.where(brand_id: website.brand_id)
	end

	def show
		respond_with @system
	end
end
