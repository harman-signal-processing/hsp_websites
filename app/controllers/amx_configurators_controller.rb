class AmxConfiguratorsController < ApplicationController
  def send_xml_file
    filename = params[:filename]
    xml = params[:xml]
    respond_to do |format|
      format.html { render plain: "This method is designed as an XML call only."}
      format.xml  { 
        send_data(xml, type: 'text/xml', filename: filename)
      }
    end  #  respond_to do |format|
  end  #  def send_xml_file
end  #  class AmxConfiguratorsController < ApplicationController
