class ServeMeThisController < ApplicationController  

  def download_media
      @attachment = Download.where(id: params[:id]).first
      
 
      #need to sort this out another time
      #redirect_to  @attachment.download.url
      redirect_to "http://" + ENV['S3_HOST_NAME'] + "/downloads/" + @attachment.download_category.slug + "/" + @attachment.download_file_name
  end
  
end
