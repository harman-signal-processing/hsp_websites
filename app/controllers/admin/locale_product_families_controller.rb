class Admin::LocaleProductFamiliesController < AdminController
  load_and_authorize_resource
  def create
    respond_to do |format|
      if @locale_product_family.save
        format.html { redirect_to([:admin, @locale_product_family.product_family], :notice => 'Product Family/Locale was successfully created.') }
        format.xml  { render :xml => @locale_product_family, :status => :created, :location => @locale_product_family }
        format.js
      else
        format.html { redirect_to([:admin, @locale_product_family.product_family], :alert => "Sorry, there was a problem with that.") }
        format.xml  { render :xml => @locale_product_family.errors, :status => :unprocessable_entity }
      end
    end    
  end
  
  def destroy
    @locale_product_family.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @locale_product_family.product_family]) }
      format.xml  { head :ok }
      format.js
    end
  end
end