class LabelSheetOrdersController < ApplicationController
  before_action :load_istomp

  def new
  	@label_sheet_order = LabelSheetOrder.new(subscribe: true)
  	if params[:epedal_id]
  		epedal = Product.find(params[:epedal_id])
  		LabelSheet.all.each do |ls|
  			@label_sheet_order.label_sheets << ls if ls.decoded_products.include?(epedal)
  		end
  	end
  end

  def create
  	@label_sheet_order = LabelSheetOrder.new(label_sheet_order_params)
  	if @label_sheet_order.save
  		session[:label_sheet_order_id] = @label_sheet_order.id
  		redirect_to thanks_label_sheet_order_path, notice: "Your request has been received."
  	else
  		render action: "new"
  	end
  end

  def thanks
  	if session[:label_sheet_order_id]
  		@label_sheet_order = LabelSheetOrder.find(session[:label_sheet_order_id])
  	else
  		redirect_to root_path and return false
  	end
  end

  def fulfill
  	@label_sheet_order = LabelSheetOrder.find(params[:id])
  	if @label_sheet_order.verify_code(params[:secret_code])
	  	@label_sheet_order.mailed_on = Date.today
	  	@label_sheet_order.save
  		render plain: "Success. Shipping date was logged."
  	else
  		render plain: "Hmmm. Something isn't right with that link."
  	end
  end

  private

  def load_istomp
  	@istomp = Product.find("istomp") || Product.new(name: "iStomp")
    @stomp_shop = @istomp.softwares.first || Software.new
  end

  def label_sheet_order_params
    params.require(:label_sheet_order).permit(:name, :email, :address, :city, :state, :postal_code, :country, :subscribe, label_sheet_ids: [])
  end

end
