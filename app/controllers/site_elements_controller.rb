class SiteElementsController < ApplicationController

  def show
    @site_element = SiteElement.find(params[:id])
    case @site_element.attachment_type
    when 'resource'
      send_resource_file(@site_element)
    when 'executable'
      send_executable_file(@site_element)
    when 'external'
      redirect_to @site_element.external_url
    end
  end

  private

  def send_executable_file(site_element)
    data = open(site_element.executable.url)
    send_data data.read,
      disposition: :attachment,
      stream: true,
      buffer_size: '4096',
      filename: site_element.executable_file_name,
      type: site_element.executable_content_type
  end

  def send_resource_file(site_element)
    data = open(site_element.resource.url)
    send_data data.read,
      disposition: 'inline',
      stream: true,
      buffer_size: '4096',
      filename: site_element.resource_file_name,
      type: site_element.resource_content_type
  end

end
