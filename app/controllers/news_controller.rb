class NewsController < ApplicationController
  before_action :set_locale
  before_action :ensure_best_url, only: :show

  # GET /news
  # GET /news.xml
  def index
    @news = News.all_for_website(website).paginate(page: params[:page], per_page: 12)
    @subtitle = ""
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @news }
      format.js
    end
  end

  def filter_by_tag
    @news = News.all_for_website(website).tagged_with(params[:tag]).paginate(page: params[:page], per_page: 20)
    @subtitle = "Filtered by tag: #{params[:tag]}"
    respond_to do |format|
      format.html { render_template action: 'index' }
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
    if !News.all_for_website(website, start_on: 99.years.ago).include?(@news) || (@news.post_on.to_date > Date.today && !(can?(:manage, @news)))
      redirect_to news_index_path, status: :moved_permanently and return
    end
    @related_news = @news.find_related_tags.where("post_on <= ?", Date.today).order("post_on DESC").limit(6)
    @recent_news = News.all_for_website(website, limit: 6) - [@news] - @related_news
    @hreflangs = @news.hreflangs(website)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @news }
    end
  end

  def update
    @news = News.where(cached_slug: params[:id]).first || News.find(params[:id])
    authorize! :update, @news
    respond_to do |format|
      if @news.update(news_params)
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
