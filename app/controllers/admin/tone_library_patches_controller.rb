class Admin::ToneLibraryPatchesController < AdminController
  load_and_authorize_resource
  # GET /admin/tone_library_patches
  # GET /admin/tone_library_patches.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @tone_library_patches }
    end
  end

  # GET /admin/tone_library_patches/1
  # GET /admin/tone_library_patches/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @tone_library_patch }
    end
  end

  # GET /admin/tone_library_patches/new
  # GET /admin/tone_library_patches/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @tone_library_patch }
    end
  end

  # GET /admin/tone_library_patches/1/edit
  def edit
  end

  # POST /admin/tone_library_patches
  # POST /admin/tone_library_patches.xml
  def create
    respond_to do |format|
      if @tone_library_patch.save
        format.html { redirect_to([:admin, @tone_library_patch.tone_library_song], :notice => 'Tone library patch was successfully created.') }
        format.xml  { render :xml => @tone_library_patch, :status => :created, :location => @tone_library_patch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tone_library_patch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/tone_library_patches/1
  # PUT /admin/tone_library_patches/1.xml
  def update
    respond_to do |format|
      if @tone_library_patch.update_attributes(params[:tone_library_patch])
        format.html { redirect_to([:admin, @tone_library_patch], :notice => 'Tone library patch was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tone_library_patch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tone_library_patches/1
  # DELETE /admin/tone_library_patches/1.xml
  def destroy
    @tone_library_patch.destroy
    respond_to do |format|
      format.html { redirect_to(admin_tone_library_patches_url) }
      format.xml  { head :ok }
      format.js
    end
  end
end
