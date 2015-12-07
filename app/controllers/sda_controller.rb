class SdaController < ApplicationController  
  before_filter :set_nav_and_footer_links
  before_action :authenticate_sda_user!
  protect_from_forgery with: :exception
  
  
  def index
    
    @user_name_and_company = current_sda_user.first_name + " " + current_sda_user.last_name + " (" + current_sda_user.company + ")"
    @messages = SdaMessage.order(post_on: :desc).first(3)
      

  end
  
  def downloads
    
    if request.post?
      @selectedcategory = params[:download][:downloadcategory]
      @selectedproduct = params[:download][:productname]
      #@products = Product.select(:id, :name).where(hidden: 0).order(live: :desc, product_category_id: :asc, product_sub_category_id: :asc, name: :asc)
      
        if @selectedcategory.to_i > 0 
          
            @products = Product.distinct
                        .select(:id, :name)
                        .where(hidden: 0)
                        .joins(products_download: :download)
                        .where(downloads: {download_category_id: @selectedcategory})
                        .order(live: :desc, product_category_id: :asc, product_sub_category_id: :asc, name: :asc)
      
        else
          
            @products = Product
                        .select(:id, :name)
                        .where(hidden: 0)
                        .order(live: :desc, product_category_id: :asc, product_sub_category_id: :asc, name: :asc)
          
        end
      
    
    else  
      @products = Product
                  .select(:id, :name)
                  .where(hidden: 0)
                  .order(live: :desc, product_category_id: :asc, product_sub_category_id: :asc, name: :asc)
    end
    
      @download = Download.new
      @download_categories = DownloadCategory.select(:id, :name).where(live: 1).order(:position, :name)
    
  end
  
  def dealer_contacts
    
  end
  
  def order_forms
    
  end
  
  def swags
    
    
  end
  
  def soundcraft_contacts
    

    
  end

end
