module PdfService
    extend ActiveSupport::Concern
      def create_pdf(name, html)
        respond_to do |format|
           format.html {
             render html: html.html_safe
           }
           format.pdf  {
             t = Time.now.localtime(Time.now.in_time_zone('America/Chicago').utc_offset)
             filename = "#{name}.#{t.month}.#{t.day}.#{t.year}_#{t.strftime("%I.%M.%S_%p")}.pdf"
             pdf = WickedPdf.new.pdf_from_string(html,:encoding => 'UTF-8')
             send_data pdf, filename: "#{filename}", encoding: "utf8"
           }
        end  #  respond_to do |format|
      end  #  def create_pdf
end  #  module PdfService
