class SoftwareAttachmentsController < ApplicationController
  before_action :set_locale

# This is used to satisfy Martin's request that file names not be changed on software attachments
  def download
    @software_attachment = SoftwareAttachment.find(params[:id])
    
    data = URI.open(@software_attachment.software_attachment.url)
    send_data data.read,
    filename: @software_attachment.software_attachment.original_filename,
    content_type: @software_attachment.software_attachment.content_type,
    disposition: :attachment
    
  end

end  #  class SoftwareAttachmentsController < ApplicationController