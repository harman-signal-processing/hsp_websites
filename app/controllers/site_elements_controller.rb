class SiteElementsController < ApplicationController
  before_action :set_locale
  load_and_authorize_resource

  def new_version
    @old_element = @site_element
    @site_element = SiteElement.new(replaces_element: @old_element.to_param)
    @return_to = request.referer
  end

  def edit
    @return_to = request.referer
  end

  def new
    @site_element = SiteElement.new(is_document: true, show_on_public_site: true)
    @site_element.products << Product.find(params[:product_id]) if params[:product_id]
    @return_to = request.referer
  end

  def show
    # binding.pry
    begin
      case @site_element.attachment_type
      when 'resource'
        # binding.pry
        send_resource_file(@site_element)
      when 'executable'
        send_executable_file(@site_element)
      when 'external'
        redirect_to @site_element.external_url
      when 'html'
        render_template
      end
    rescue => e
      # binding.pry
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def send_executable_file(site_element)
    data = URI.open(site_element.executable.url)
    send_data data.read,
      disposition: :attachment,
      stream: true,
      buffer_size: '4096',
      filename: site_element.executable_file_name.gsub(/_original/, ''),
      type: site_element.executable_content_type
  end

  def send_resource_file(site_element)
    # binding.pry
    # data = URI.open("/home/ubuntu/environment/public#{site_element.resource.url}")
    # binding.pry
    # if Rails.env.development? && !!(ENV['USE_PRODUCTION_ASSETS'].to_i == 0)
    #   # binding.pry
      
    #   # this does NOT work
    #   # data = URI.open(site_element.resource.url)
    #   # "https://adn.harmanpro.com/site_elements/resources/1762_1489598313/Case-Study-Juniper-Networks_original.jpg"
      
    #   # this works
    #   # data = URI.open("/home/ubuntu/environment/public#{site_element.resource.url}")
    #   # "/home/ubuntu/environment/publichttps://adn.harmanpro.com/site_elements/resources/1762_1489598313/Case-Study-Juniper-Networks_original.jpg" 
      
    #   # this does NOT work
    #   # data = URI.open("#{Rails.root}/public#{site_element.resource.url}")
    #   # "/home/ubuntu/environment/publichttps://adn.harmanpro.com/site_elements/resources/1762_1489598313/Case-Study-Juniper-Networks_original.jpg"
      
    #   # this does NOT work
    #   data = URI.open("#{Rails.root}/public#{site_element.resource.path}")
    #   # "/home/ubuntu/environment/publicsite_elements/resources/1762_1489598313/Case-Study-Juniper-Networks_original.jpg"
      
    #   # path = Rails.root.join("public","#{site_element.resource.path}").to_s
    #   # binding.pry
    #   # data = URI.open(path)
      
    #   # stop here
    #   binding.pry
      
    # else  # in production environment or in development environment and USE_PRODUCTION_ASSETS set to true (1)
    # binding.pry
      data = URI.open(site_element.resource.url)
    # end

# binding.pry
    send_data data.read,
      disposition: 'inline',
      stream: true,
      buffer_size: '4096',
      filename: site_element.resource_file_name.gsub(/_original/, ''),
      type: site_element.resource_content_type
  end

end
