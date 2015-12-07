class GetStartedController < ApplicationController  
  before_filter :set_nav_and_footer_links
  include SupportHelper
  
  def index
    
  end
  
  def ui
     
    if(params.has_key?(:validate))
      @validate = params[:validate]
      
      if(params.has_key?(:query))
        @query = params[:query]
        if @validate == "serial"
          if UsersProduct.exists?(:serial => @query, :product_id => [206, 207])
            flash[:notice_ui] = t('ui_get_started_registered')
            #redirect_to "/get-started/ui?validate=serial"
          else
            flash[:notice_ui] = t('get_started_not_registered')
            #redirect_to "/get-started/ui?validate=serial"            
          end
         
        end
      end
        
    else
      @validate = "reg"
    end
          
     if request.post?
      @user = User.new(users_product_params)
      if @user.save
        
          this_subject_line = create_get_started_product_registration_subject() 
          this_body = create_product_registration_body()
          this_recipients = create_product_registration_recipients()
          send_email(this_recipients, 'soundcraft.marketing@harman.com', this_subject_line, this_body)
          
         flash[:notice_ui] = t('ui_get_started_registered')
        redirect_to "/get-started/ui?validate=serial"
      end
    else
      flash = nil
      @user = User.new
      users_product = @user.users_products.build
    end

  end
  
  def signature

    if(params.has_key?(:validate))
      @validate = params[:validate]
      
      if(params.has_key?(:query))
        @query = params[:query]
        if @validate == "serial"
          if UsersProduct.exists?(:serial => @query, :product_id => [208, 209, 210, 211])
            flash[:notice_signature] = t('signature_get_started_registered')
            #redirect_to "/get-started/ui?validate=serial"
          else
            flash[:notice_signature] = t('get_started_not_registered')
            #redirect_to "/get-started/ui?validate=serial"            
          end
         
        end
      end
        
    else
      @validate = "reg"
    end
          
     if request.post?
      @user = User.new(users_product_params)
      if @user.save
        
          this_subject_line = create_get_started_product_registration_subject() 
          this_body = create_product_registration_body()
          this_recipients = create_product_registration_recipients()
          send_email(this_recipients, 'soundcraft.marketing@harman.com', this_subject_line, this_body)
          
         flash[:notice_signature] = t('signature_get_started_registered')
        redirect_to "/get-started/signature?validate=serial"
      end
    else
      flash = nil
      @user = User.new
      users_product = @user.users_products.build
    end
    
  end
  
    def signature_mtk

    if(params.has_key?(:validate))
      @validate = params[:validate]
      
      if(params.has_key?(:query))
        @query = params[:query]
        if @validate == "serial"
          if UsersProduct.exists?(:serial => @query, :product_id => [212, 213])
            flash[:notice_signature_mtk] = t('signature_mtk_get_started_registered')
            #redirect_to "/get-started/ui?validate=serial"
          else
            flash[:notice_signature_mtk] = t('get_started_not_registered')
            #redirect_to "/get-started/ui?validate=serial"            
          end
         
        end
      end
        
    else
      @validate = "reg"
    end
          
     if request.post?
      @user = User.new(users_product_params)
      if @user.save
        
          this_subject_line = create_get_started_product_registration_subject() 
          this_body = create_product_registration_body()
          this_recipients = create_product_registration_recipients()
          send_email(this_recipients, 'soundcraft.marketing@harman.com', this_subject_line, this_body)
          
         flash[:notice_signature_mtk] = t('signature_mtk_get_started_registered')
        redirect_to "/get-started/signature_mtk?validate=serial"
      end
    else
      flash = nil
      @user = User.new
      users_product = @user.users_products.build
    end
    
  end
  
    def si_impact

    if(params.has_key?(:validate))
      @validate = params[:validate]
      
      if(params.has_key?(:query))
        @query = params[:query]
        if @validate == "serial"
          if UsersProduct.exists?(:serial => @query, :product_id => [218])
            flash[:notice_si_impact] = t('si_impact_get_started_registered')
            #redirect_to "/get-started/ui?validate=serial"
          else
            flash[:notice_si_impact] = t('get_started_not_registered')
            #redirect_to "/get-started/ui?validate=serial"            
          end
         
        end
      end
        
    else
      @validate = "reg"
    end
          
     if request.post?
      @user = User.new(users_product_params)
      if @user.save
        
          this_subject_line = create_get_started_product_registration_subject() 
          this_body = create_product_registration_body()
          this_recipients = create_product_registration_recipients()
          send_email(this_recipients, 'soundcraft.marketing@harman.com', this_subject_line, this_body)
          
         flash[:notice_si_impact] = t('si_impact_get_started_registered')
        redirect_to "/get-started/si-impact?validate=serial"
      end
    else
      flash = nil
      @user = User.new
      users_product = @user.users_products.build
    end
    
  end
  
  private
  


  
  def users_product_params
   params.require(:user).permit(:salutation_id, :first_name, :last_name, :email, :email2, 
   :job_title, :company, :address1, :address2, :city, :county, :post_code, :country_id,
   :phone, :phone2, :soundcraft_optin, :third_party_optin,
   :users_products_attributes => [:serial, :product_id, :purchased_date, :purchased_from, :purchased_amount,
     :comment, :application_id, :influence, :hear_from, :user_id])
  end
  
end
