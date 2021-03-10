class PdfsController < ApplicationController
  include PdfService
  def create
    name = params[:pdfName]
    html = params[:pdfContent]
    create_pdf(name, html) if name.present? && html.present?
  end  #  def create
end  #  class PdfsController < ApplicationController
