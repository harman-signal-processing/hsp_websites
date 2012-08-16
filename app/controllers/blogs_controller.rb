class BlogsController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, only: :show
  
  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = website.blogs
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blogs }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    respond_to do |format|
      format.html {
        render layout: @blog.layout
      }
      format.xml { render xml: @blog.published_articles }
      format.json { render json: @blog.published_articles }
    end
  end

  protected
  
  def ensure_best_url
    @blog = Blog.find(params[:id])
    redirect_to @blog, status: :moved_permanently unless @blog.friendly_id_status.best?
  end
  
end
