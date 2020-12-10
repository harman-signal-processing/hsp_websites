class SiteElementsController < ApplicationController
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
    begin
      case @site_element.attachment_type
      when 'resource'
        send_resource_file(@site_element)
      when 'executable'
        send_executable_file(@site_element)
      when 'external'
        redirect_to @site_element.external_url
      when 'html'
        render_template
      end
    rescue
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def send_executable_file(site_element)
    data = open(site_element.executable.url)
    send_data data.read,
      disposition: :attachment,
      stream: true,
      buffer_size: '4096',
      filename: site_element.executable_file_name.gsub(/_original/, ''),
      type: site_element.executable_content_type
  end

  def send_resource_file(site_element)
    data = open(site_element.resource.url)
    send_data data.read,
      disposition: 'inline',
      stream: true,
      buffer_size: '4096',
      filename: site_element.resource_file_name.gsub(/_original/, ''),
      type: site_element.resource_content_type
  end

end
