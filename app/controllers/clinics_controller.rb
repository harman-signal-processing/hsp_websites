class ClinicsController < ApplicationController
  # GET /clinics
  # GET /clinics.xml
  def index
    @clinics = Clinic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @clinics }
    end
  end

  # GET /clinics/1
  # GET /clinics/1.xml
  def show
    @clinic = Clinic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @clinic }
    end
  end
end
