class NewsController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, only: :show
  
  # GET /news
  # GET /news.xml
  def index
    @news = News.all_for_website(website)
    @hide_archive = false
    if @news.length < 5
      @news += News.archived(website) 
      @hide_archive = true
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @news }
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
      redirect_to news_index_path and return
    end
    @old_news = !!(News.archived(website))
    @recent_news = News.all_for_website(website, limit: 6) - [@news]
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @news }
    end
  end
  
  protected
  
  def ensure_best_url
    @news = News.where(cached_slug: params[:id]).first || News.find(params[:id])
    # redirect_to @news, status: :moved_permanently unless @news.friendly_id_status.best?
  end

end
