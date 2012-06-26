class Admin::NewsController < AdminController
  load_and_authorize_resource
  after_filter :expire_news_index_cache, :only => [:create, :update, :destroy]
  # GET /admin/news
  # GET /admin/news.xml
  def index
    @news = @news.where(:brand_id => website.brand_id).order("post_on DESC")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /admin/news/1
  # GET /admin/news/1.xml
  def show
    @news_product = NewsProduct.new(:news => @news)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /admin/news/new
  # GET /admin/news/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /admin/news/1/edit
  def edit
  end

  # POST /admin/news
  # POST /admin/news.xml
  def create
    @news.brand = website.brand
    respond_to do |format|
      if @news.save
        format.html { redirect_to([:admin, @news], :notice => 'News was successfully created.') }
        format.xml  { render :xml => @news, :status => :created, :location => @news }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @news.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/news/1
  # PUT /admin/news/1.xml
  def update
    respond_to do |format|
      if @news.update_attributes(params[:news])
        format.html { redirect_to([:admin, @news], :notice => 'News was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/news/1
  # DELETE /admin/news/1.xml
  def destroy
    @news.destroy
    respond_to do |format|
      format.html { redirect_to(admin_news_index_url) }
      format.xml  { head :ok }
    end
  end
end
