class AmxDxlinkToolController < ApplicationController
  before_action :set_locale
  
  def index
    @tx = AmxDxlinkDeviceInfo.where("model=? and type_short_name='tx'", params[:tx]).first
    @rx = AmxDxlinkDeviceInfo.where("model=? and type_short_name='rx'", params[:rx]).first
    @combo = AmxDxlinkCombo.where("tx_id = ? and rx_id = ?", @tx.id, @rx.id).first if @tx.present? && @rx.present?
    render template: "#{website.folder}/tool/dxlink/index", layout: set_layout
  end

end  #  class AmxDxlinkToolController < ApplicationController

