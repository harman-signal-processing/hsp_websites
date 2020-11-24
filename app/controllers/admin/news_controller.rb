class Admin::NewsController < AdminController
  before_action :initialize_news, only: :create
  load_and_authorize_resource

  # GET /admin/news
  # GET /admin/news.xml
  def index
    @this_brand = params[:this_brand].present? ? !!(params[:this_brand].to_i > 0) : true
    @search = (@this_brand) ? website.brand.news.ransack(params[:q]) : News.ransack(params[:q])
    @news = @search.result.paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @news }
    end
  end

  # GET /admin/news/1
  # GET /admin/news/1.xml
  def show
    @news_product = NewsProduct.new(news: @news)
    @products = Product.all_for_website(website)
    @news_image = NewsImage.new(news: @news)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @news }
    end
  end

  # GET /admin/news/new
  # GET /admin/news/new.xml
  def new
    @news.brands << website.brand
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
      if @news.update(news_params)
        format.html { redirect_to([:admin, @news], notice: 'News was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated news: #{@news.title}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_news_photo
    @news.update(news_photo: nil)
    redirect_to([:admin, @news], notice: "Main photo was removed.")
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
    params.require(:news).permit(
      :post_on,
      :title,
      :body,
      :keywords,
      :news_photo,
      :quote,
      :video_ids,
      :old_id,
      :old_url
    )
  end
end
