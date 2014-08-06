class Admin::BlogsController < AdminController
  before_filter :initialize_blog, only: :create
  load_and_authorize_resource
  
  # GET /admin/blogs
  # GET /admin/blogs.xml
  def index
    @blogs = @blogs.where(brand_id: website.brand_id)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { 
        @blogs = Blog.all
        render xml: @blogs 
      }
    end
  end

  # GET /admin/blogs/1
  # GET /admin/blogs/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @blog }
    end
  end

  # GET /admin/blogs/new
  # GET /admin/blogs/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @blog }
    end
  end

  # GET /admin/blogs/1/edit
  def edit
  end

  # POST /admin/blogs
  # POST /admin/blogs.xml
  def create
    @blog.brand_id = website.brand_id
    respond_to do |format|
      if @blog.save
        format.html { redirect_to([:admin, @blog], notice: 'Blog was successfully created.') }
        format.xml  { render xml: @blog, status: :created, location: @blog }
        website.add_log(user: current_user, action: "Created blog: #{@blog.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/blogs/1
  # PUT /admin/blogs/1.xml
  def update
    respond_to do |format|
      if @blog.update_attributes(blog_params)
        format.html { redirect_to([:admin, @blog], notice: 'Blog was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated blog: #{@blog.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/blogs/1
  # DELETE /admin/blogs/1.xml
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to(admin_blogs_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted blog: #{@blog.name}")
  end

  private

  def initialize_blog
    @blog = Blog.new(blog_params)
  end

  def blog_params
    params.require(:blog).permit!
  end  
end
