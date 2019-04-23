class NewsController < ApplicationController
  before_action :set_locale
  before_action :ensure_best_url, only: :show

  # GET /news
  # GET /news.xml
  def index
    @news = News.all_for_website(website)
    @hide_archive = false
    if @news.length < 5
      @news += News.archived(website)
      @hide_archive = true
    end
    @news = @news.paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @news }
      format.js
    end
  end

  # GET /news/archived
  # GET /news/archived.xml
  def archived
    @news = News.archived(website)
    respond_to do |format|
      format.html { render_template } # archived.html.erb
      format.xml  { render xml: @news }
    end
  end

  # GET /news/1
  # GET /news/1.xml
  def show
    if !website.news.include?(@news) || (@news.post_on.to_date > Date.today && !(can?(:manage, @news)))
      redirect_to news_index_path, status: :moved_permanently and return
    end
    @old_news = !!(News.archived(website))
    @recent_news = News.all_for_website(website, limit: 6) - [@news]
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @news }
    end
  end

  def update
    @news = News.where(cached_slug: params[:id]).first || News.find(params[:id])
    authorize! :update, @news
    respond_to do |format|
      if @news.update_attributes(news_params)
        format.html { redirect_to(@news, notice: 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "show" }
        format.xml  { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /news/martin_redirect/CaseStory:1
  def martin_redirect
    old_id = params[:id]
    if params[:id].match(/\:/)
      old_id = params[:id].split(/\:/).last
    end

    redirect_path = news_index_path
    if website.brand.news.where(old_id: old_id).exists?
      redirect_path = website.brand.news.where(old_id: old_id).first
    end
    redirect_to redirect_path, status: :moved_permanently and return
  end

  protected

  def ensure_best_url
    @news = News.where(cached_slug: params[:id]).first || News.find(params[:id])
    # redirect_to @news, status: :moved_permanently unless @news.friendly_id_status.best?
  end

  def news_params
    params.require(:news).permit(:tag_list, :tags)
  end

end
