class Admin::BlogArticlesController < AdminController
  before_filter :initialize_blog_article, only: :create
  load_and_authorize_resource
  
  # GET /admin/blog_articles
  # GET /admin/blog_articles.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { 
        @blog_articles = BlogArticle.all
        render xml: @blog_articles 
      }
    end
  end

  # GET /admin/blog_articles/1
  # GET /admin/blog_articles/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @blog_article }
    end
  end

  # GET /admin/blog_articles/new
  # GET /admin/blog_articles/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @blog_article }
    end
  end

  # GET /admin/blog_articles/1/edit
  def edit
  end

  # POST /admin/blog_articles
  # POST /admin/blog_articles.xml
  def create
    respond_to do |format|
      if @blog_article.save
        format.html { redirect_to([:admin, @blog_article], notice: 'Blog Article was successfully created.') }
        format.xml  { render xml: @blog_article, status: :created, location: @blog_article }
        website.add_log(user: current_user, action: "Created blog article: #{@blog_article.title}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @blog_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/blog_articles/1
  # PUT /admin/blog_articles/1.xml
  def update
    respond_to do |format|
      if @blog_article.update_attributes(blog_article_params)
        format.html { redirect_to([:admin, @blog_article], notice: 'Blog Article was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated blog article: #{@blog_article.title}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @blog_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/blog_articles/1
  # DELETE /admin/blog_articles/1.xml
  def destroy
    @blog_article.destroy
    respond_to do |format|
      format.html { redirect_to(admin_blog_articles_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted blog article: #{@blog_article.title}")
  end

  private

  def initialize_blog_article
    @blog_article = BlogArticle.new(blog_article_params)
  end

  def blog_article_params
    params.require(:blog_article).permit!
  end  
end
