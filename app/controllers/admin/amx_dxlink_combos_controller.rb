class Admin::AmxDxlinkCombosController < AdminController
	before_action :initialize_dxlink_combo, only: :create
  load_and_authorize_resource class: "AmxDxlinkCombo"
	
  # GET /admin/amx_dxlink_combos/new
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
    end
  end
  
  # POST /admin/amx_dxlink_combos
  def create
    respond_to do |format|
      if @amx_dxlink_combos.present?
        begin
          @amx_dxlink_combos.each do |amx_dxlink_combo|
            begin
              amx_dxlink_combo.save!
              website.add_log(user: current_user, action: "Paired tx: #{amx_dxlink_combo.tx.model} with rx: #{amx_dxlink_combo.rx.model}")
              format.js
            rescue => e
              @error = "Error: #{e.message} : tx: #{amx_dxlink_combo.tx.model} rx: #{amx_dxlink_combo.rx.model}"
              format.js { render template: "admin/amx_dxlink_combos/create_error" }
            end
          end  #  @amx_dxlink_combos.each do |amx_dxlink_combo|
        rescue => e
          @error = "Error: #{e.message}"
          format.js { render template: "admin/amx_dxlink_combos/create_error" }
        end  #  begin
      end  #  if @amx_dxlink_combos.present?
    end  #  respond_to do |format|
  end  #  def create

  def show
    @attibute_name_list = AmxDxlinkAttributeName.all.order(:position)
    @combo_attributes = @amx_dxlink_combo.combo_attributes
    if @combo_attributes.present?
      # do nothing, note we may need to check to see
      # if any new attribute names have been created and if so create a combo_attribute record for it
    else
    # We're creating new combo attributes as an intitialization step the first time a DXLink Pairing details are reviewed by an admin. 
    # There is probably a better way to do this.
      @attibute_name_list.each do |attribute_name|
        new_combo = AmxDxlinkComboAttribute.new(value: '', amx_dxlink_attribute_name_id: attribute_name.id, amx_dxlink_combo_id: @amx_dxlink_combo.id)
        did_it_save = new_combo.save!

        # refresh @amx_dxlink_combo after attribute updates
        @amx_dxlink_combo = AmxDxlinkCombo.find(@amx_dxlink_combo.id)
      end  #  @attibute_name_list.each do |attribute_name|
    end  #  if @combo_attributes.present?
  end  #  def show

  def _form
  end

  # DELETE /admin/amx_dxlink_combos/1
  def destroy
    @calling_device = AmxDxlinkDeviceInfo.find(params[:calling_device])
    @amx_dxlink_combo.destroy
    respond_to do |format|
      format.js
    end
    website.add_log(user: current_user, action: "Removed amx dxlink pairing tx:#{@amx_dxlink_combo.tx.model} - rx:#{@amx_dxlink_combo.rx.model}")
  end

  private

    def initialize_dxlink_combo
      tx_id = amx_dxlink_combo_params[:tx_id]
      rx_id = amx_dxlink_combo_params[:rx_id]
      @amx_dxlink_combos = []

      if tx_id.is_a?(Array)
        reciever_id = rx_id
        tx_id.reject(&:blank?).each do |transmitter_id|
          @amx_dxlink_combos << AmxDxlinkCombo.new({tx_id: transmitter_id, rx_id: reciever_id})
        end
      else
        @calling_device = AmxDxlinkDeviceInfo.find(tx_id)
      end

      if rx_id.is_a?(Array)
        transmitter_id = tx_id
        rx_id.reject(&:blank?).each do |reciever_id|
          @amx_dxlink_combos << AmxDxlinkCombo.new({tx_id: transmitter_id, rx_id: reciever_id})
        end
      else
        @calling_device = AmxDxlinkDeviceInfo.find(rx_id)
      end
    end  #  def initialize_dxlink_combo

    def amx_dxlink_combo_params
      params.require(:amx_dxlink_combo).permit(:tx_id, :rx_id, rx_id: [], tx_id: [])
    end

end  #  class Admin::AmxDxlinkCombosController < ApplicationController
