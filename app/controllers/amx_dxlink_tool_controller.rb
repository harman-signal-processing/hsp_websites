class AmxDxlinkToolController < ApplicationController
  before_action :set_locale
  
  def index
    @devices_list = AmxDxlinkCombo.ordered_by_tx_model

    if amx_dxlink_tool_params.present?
      @combo = AmxDxlinkCombo.find(amx_dxlink_tool_params[:combo_id])
    end
    render template: "#{website.folder}/tool/dxlink/index", layout: set_layout
  end

	private

  def amx_dxlink_tool_params
    params.require(:amx_dxlink_combo).permit(:combo_id)
  end
end  #  class AmxDxlinkToolController < ApplicationController

