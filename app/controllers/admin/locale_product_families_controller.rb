class Admin::LocaleProductFamiliesController < AdminController
  before_action :initialize_locale_product_family, only: :create
  load_and_authorize_resource
  
  def create
    respond_to do |format|
      if @locale_product_family.save
        format.html { redirect_to([:admin, @locale_product_family.product_family], notice: 'Product Family/Locale was successfully created.') }
        format.xml  { render xml: @locale_product_family, status: :created, location: @locale_product_family }
        format.js
      else
        format.html { redirect_to([:admin, @locale_product_family.product_family], alert: "Sorry, there was a problem with that.") }
        format.xml  { render xml: @locale_product_family.errors, status: :unprocessable_entity }
      end
    end
    website.add_log(user: current_user, action: "Created a locale/product family")    
  end
  
  def destroy
    @locale_product_family.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @locale_product_family.product_family]) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted a locale/product family")
  end

  private

  def initialize_locale_product_family
    @locale_product_family = LocaleProductFamily.new(locale_product_family_params)
  end

  def locale_product_family_params
    params.require(:locale_product_family).permit!
  end
end
