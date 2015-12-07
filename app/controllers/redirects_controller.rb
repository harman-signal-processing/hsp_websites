class RedirectsController < ApplicationController  

  
  def applications

     if params[:aid]
        redirect_to "/products" #temp until pages have been created, :status => 301
      else
        redirect_to "/products"
     end

  end
  
  def product_cat

    case params[:cat]
    when 1
       redirect_to "/products/mixing-consoles"
    when 2
      redirect_to "/products/stageboxes" 
    when 3
      redirect_to "/products/option-cards"
    when 4
      redirect_to "/products/recording-interfaces" 
    when 5
      redirect_to "/products/plugins" 
    when 6
      redirect_to "/products/mobile-apps" 
    else
      redirect_to "/products" 
    end  
    
  end
  
  def product

    if params[:pid]
      if params[:pid] = 191
        redirect_to "/products/si-expression-3", :status => 301
      else
        redirect_to "/products/#{params[:pid]}", :status => 301
      end
      
      
    else
      redirect_to "/products"  
    end

  end

end
