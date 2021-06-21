class JblVertecVtxOwnersController < ApplicationController
  before_action :set_locale
  
  def new
    @jbl_vertec_vtx_owner = JblVertecVtxOwner.new()
    render template: "#{website.folder}/vertec_vtx_owners/form", layout: set_layout
  end 

  def create
    vtx_products = jbl_vertec_vtx_owner_params[:vtx_products].reject(&:blank?)
    vertec_products = jbl_vertec_vtx_owner_params[:vertec_products].reject(&:blank?)
    all_products = (vtx_products + vertec_products).map{|item| item.squish!}
    @owner = JblVertecVtxOwner.new(jbl_vertec_vtx_owner_params)
    @owner.rental_products = all_products.join(" |--| ")
    if !@owner.valid?
      redirect_to vertec_vtx_owners_signup_form_path, alert: "Please complete all required fields" and return false
    end
    
    respond_to do |format|
      if @owner.save
        SiteMailer.delay.jbl_vertec_vtx_owner_form(@owner, website.brand.jbl_vertec_vtx_owner_form_recipients)
        format.html { redirect_to vertec_vtx_owners_signup_thankyou_path }
      else
        format.html { redirect_to vertec_vtx_owners_signup_form_path, alert: @owner.errors }
      end
    end
  end
  
  def thankyou
    render template: "#{website.folder}/vertec_vtx_owners/thankyou", layout: set_layout
  end
  
  private
  
  def jbl_vertec_vtx_owner_params
    params.require(:jbl_vertec_vtx_owner).permit(:company_name, :address, :city, :postal_code, :country, :phone, :email, :contact_name, :rental_products, :comment, vertec_products: [], vtx_products: [])
  end  
end  #  class JblVertecVtxOwnersController < ApplicationController