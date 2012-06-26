class BlogArticlesController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, :only => :show
  
  # GET /blog/1/blog_articles/1
  def show
    render :layout => @blog.layout
  end

  protected
  
  def ensure_best_url
    @blog_article = BlogArticle.find(params[:id])
    redirect_to @blog_article, :status => :moved_permanently unless @blog_article.friendly_id_status.best?
  end

end
