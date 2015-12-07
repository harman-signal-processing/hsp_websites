class DownloadsController < ApplicationController  
before_filter :set_nav_and_footer_links
  
  
  def index

      

  end
  
  def images

      

  end
  
  
  def get_file_type(content_type)
    ft = FileType.select(:name).where(file_typeL: content_type).first
    ft.html_safe
  end

  
end
