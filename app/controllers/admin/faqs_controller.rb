class Admin::FaqsController < AdminController
  load_and_authorize_resource
  # GET /faqs
  # GET /faqs.xml
  def index
    @faqs = @faqs.where(:product_id => website.products.collect{|p| p.id}).sort_by(&:sort_key)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @faqs }
    end
  end

  # GET /faqs/1
  # GET /faqs/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @faq }
    end
  end

  # GET /faqs/new
  # GET /faqs/new.xml
  def new
    if params[:product_id]
      @faq.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @faq }
    end
  end

  # GET /faqs/1/edit
  def edit
  end

  # POST /faqs
  # POST /faqs.xml
  def create
    respond_to do |format|
      if @faq.save
        format.html { redirect_to([:admin, @faq], :notice => 'Question was successfully created.') }
        format.xml  { render :xml => @faq, :status => :created, :location => @faq }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @faq.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /faqs/1
  # PUT /faqs/1.xml
  def update
    respond_to do |format|
      if @faq.update_attributes(params[:faq])
        format.html { redirect_to([:admin, @faq], :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @faq.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /faqs/1
  # DELETE /faqs/1.xml
  def destroy
    @faq.destroy
    respond_to do |format|
      format.html { redirect_to(admin_faqs_url) }
      format.xml  { head :ok }
    end
  end
end
