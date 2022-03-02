class Admin::CustomizableAttributeValuesController < AdminController
  load_and_authorize_resource

  def destroy
    @customizable_attribute_value.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @customizable_attribute_value.product]) }
      format.js
      format.xml  { head :ok }
    end
  end

end
