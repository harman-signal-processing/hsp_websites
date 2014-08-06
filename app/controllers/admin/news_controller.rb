class Admin::NewsController < AdminController
  before_filter :initialize_news, only: :create
  load_and_authorize_resource
  
  # GET /admin/news
  # GET /admin/news.xml
  def index
    # @news = @news.where(brand_id: website.brand_id).order("post_on DESC")
    @search = website.brand.news.ransack(params[:q])
    @news = @search.result
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @news }
    end
  end

  # GET /admin/news/1
  # GET /admin/news/1.xml
  def show
    @news.from = "#{website.brand.name.downcase}.enews@harman.com"
    @news.to = "config.hpro_execs"
    @news_product = NewsProduct.new(news: @news)
    @products = Product.all_for_website(website)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @news }
    end
  end

  # GET /admin/news/new
  # GET /admin/news/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @news }
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
        format.html { redirect_to([:admin, @news], notice: 'News was successfully created.') }
        format.xml  { render xml: @news, status: :created, location: @news }
        website.add_log(user: current_user, action: "Created news: #{@news.title}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/news/1
  # PUT /admin/news/1.xml
  def update
    respond_to do |format|
      if @news.update_attributes(news_params)
        format.html { redirect_to([:admin, @news], notice: 'News was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated news: #{@news.title}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/news/1/notify
  def notify
    from = params[:news][:from] || website.support_email
    to = params[:news][:to] || "config.hpro_execs"
    @news.notify(from: from, to: to)
    redirect_to([:admin, @news], notice: 'Notifications to the Harman Pro executives are being sent.')
  end

  # DELETE /admin/news/1
  # DELETE /admin/news/1.xml
  def destroy
    @news.destroy
    respond_to do |format|
      format.html { redirect_to(admin_news_index_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted news: #{@news.title}")
  end

  private

  def initialize_news
    @news = News.new(news_params)
  end

  def news_params
    params.require(:news).permit!
  end
end
