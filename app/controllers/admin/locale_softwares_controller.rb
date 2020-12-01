class Admin::LocaleSoftwaresController < AdminController
  before_action :initialize_locale_software, only: :create
  load_and_authorize_resource

  def create
    respond_to do |format|
      if @locale_software.save
        format.html { redirect_to([:admin, @locale_software.software], notice: 'Software/Locale was successfully created.') }
        format.xml  { render xml: @locale_software, status: :created, location: @locale_software }
        format.js
      else
        format.html { redirect_to([:admin, @locale_software.software], alert: "Sorry, there was a problem with that.") }
        format.xml  { render xml: @locale_software.errors, status: :unprocessable_entity }
      end
    end
    website.add_log(user: current_user, action: "Created a locale/software")
  end

  def destroy
    @locale_software.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @locale_software.software]) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted a locale/software")
  end

  private

  def initialize_locale_software
    @locale_software = LocaleSoftware.new(locale_software_params)
  end

  def locale_software_params
    params.require(:locale_software).permit!(:locale, :software_id)
  end
end

