class Admin::VipProgrammerMarketsController < AdminController
	before_action :initialize_vip_programmer_market, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerMarket", except: [:update_order]
  skip_authorization_check only: [:update_order]
  
  
  # GET /admin/vip_programmer_markets
  # GET /admin/vip_programmer_markets.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_market }
    end
  end

  # GET /admin/vip_programmer_markets/1
  # GET /admin/vip_programmer_markets/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_market }
    end
  end   
  
  # GET /admin/vip_programmer_markets/new
  # GET /admin/vip_programmer_markets/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_market }
    end
  end

  # GET /admin/vip_programmer_markets/1/edit
  def edit
  end  
  
  # POST /admin/vip_programmer_markets
  # POST /admin/vip_programmer_markets.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_markets.present?
        begin
          @vip_programmer_markets.each do |vip_programmer_market|
            begin
              vip_programmer_market.save!
              website.add_log(user: current_user, action: "Associated #{vip_programmer_market.programmer.name} with #{vip_programmer_market.market.name}")
              format.js
            rescue
              format.js { render template: "admin/vip_programmer_markets/create_error" }
            end
          end  #  @vip_programmer_markets.each do |vip_programmer_market|
          
        rescue
          format.js { render template: "admin/vip_programmer_markets/create_error" }
        end        
      else       
        if @vip_programmer_market.save
          format.html { redirect_to([:admin, @vip_programmer_market], notice: 'Programmer market was successfully created.') }
          format.xml  { render xml: @vip_programmer_market, status: :created, location: @vip_programmer_market }
          format.js 
          website.add_log(user: current_user, action: "Associated a market with #{@vip_programmer_market.programmer.name}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @vip_programmer_market.errors, status: :unprocessable_entity }
          format.js { render template: "admin/vip_programmer_markets/create_error" }
        end
      end
    end  #  respond_to do |format|
  end  #  def create   
  
  # PUT /admin/vip_programmer_markets/1
  # PUT /admin/vip_programmer_markets/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_market.update_attributes(vip_programmer_market_params)
        format.html { redirect_to([:admin, @vip_programmer_market], notice: 'Programmer market was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_market.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def update_order
    update_list_order(Vip::ProgrammerMarket, params["vip_programmer_market"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted VIP programmer markets")
  end   
  
  # DELETE /admin/vip_programmer_markets/1
  # DELETE /admin/vip_programmer_markets/1.xml
  def destroy
    @called_from = params[:called_from] || "vip_programmer"
    @vip_programmer_market.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_markets_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a market from #{@vip_programmer_market.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_market
      if vip_programmer_market_params[:vip_market_id].is_a?(Array)
        @vip_programmer_markets = []
        vip_programmer_id = vip_programmer_market_params[:vip_programmer_id]
        vip_programmer_market_params[:vip_market_id].reject(&:blank?).each do |market|
          @vip_programmer_markets << Vip::ProgrammerMarket.new({vip_programmer_id: vip_programmer_id, vip_market_id: market})
        end        
      else
        @vip_programmer_market = Vip::ProgrammerMarket.new(vip_programmer_market_params)
      end	 	    
	  end  #  def initialize_vip_programmer_market
	
	  def vip_programmer_market_params
	    params.require(:vip_programmer_market).permit!
	  end  
end
