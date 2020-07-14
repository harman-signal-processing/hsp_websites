class Admin::VipMarketsController < AdminController
  load_and_authorize_resource class: "Vip::Market"

  def index
    @vip_markets = Vip::Market.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_markets }
      format.json  { render json: @vip_markets }
    end    
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_market = Vip::Market.find(params[:id])
    respond_to do |format|
      if @vip_market.update(vip_market_params)
        format.html { redirect_to(admin_vip_markets_path, notice: 'AMX VIP Market was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip market: #{@vip_market.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_market.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_market = Vip::Market.new(vip_market_params)
    respond_to do |format|
      if @vip_market.save

        format.html { redirect_to(admin_vip_markets_path, notice: 'AMX VIP Market was successfully created.') }
        format.xml  { render xml: @vip_market, status: :created, location: @vip_market }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip market #{@vip_market.name}")
      else
        format.html { redirect_to(admin_vip_markets_path, notice: 'There was a problem creating the AMX VIP Market.') }
        format.xml  { render xml: @vip_market.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end    
  
  # DELETE /vip_markets/1
  # DELETE /vip_markets/1.xml
  def destroy
    @vip_market.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_markets_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip market: #{@vip_market.name}")
  end   
  
  private
  
    def vip_market_params
  	  params.require(:vip_market).permit!
    end     

end
