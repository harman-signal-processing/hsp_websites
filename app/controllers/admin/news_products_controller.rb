class Admin::NewsProductsController < AdminController
  before_action :initialize_news_product, only: :create
  load_and_authorize_resource

  # GET /admin/news_products
  # GET /admin/news_products.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @news_products }
    end
  end

  # GET /admin/news_products/1
  # GET /admin/news_products/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @news_product }
    end
  end

  # GET /admin/news_products/new
  # GET /admin/news_products/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @news_product }
    end
  end

  # GET /admin/news_products/1/edit
  def edit
  end

  # POST /admin/news_products
  # POST /admin/news_products.xml
  def create
    @called_from = params[:called_from]
    respond_to do |format|
      
      if @news_products.present?
        begin
          @news_products.each do |news_product|
            begin
              news_product.save!
              website.add_log(user: current_user, action: "Added #{news_product.product.name} to #{news_product.news.title}")
              format.js
            rescue
              # format.js { render template: "admin/news_products/create_error" }
            end
          end  #  @news_products.each do |news_product|
        rescue
          # format.js { render template: "admin/news_products/create_error" }
        end        
      else
        if @news_product.save
          format.html { redirect_to([:admin, @news_product], notice: 'News Product was successfully created.') }
          format.xml  { render xml: @news_product, status: :created, location: @news_product }
          format.js
          website.add_log(user: current_user, action: "Added #{@news_product.product.name} to news story")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @news_product.errors, status: :unprocessable_entity }
          format.js
        end
      end  #  if @product_softwares.present?
    end  #  respond_to do |format|
  end  #  def create

  # PUT /admin/news_products/1
  # PUT /admin/news_products/1.xml
  def update
    respond_to do |format|
      if @news_product.update_attributes(news_product_params)
        format.html { redirect_to([:admin, @news_product], notice: 'News Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @news_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/news_products/1
  # DELETE /admin/news_products/1.xml
  def destroy
    @called_from = params[:called_from]
    @news_product.destroy
    respond_to do |format|
      format.html { redirect_to(admin_news_products_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Unlinked news/product #{@news_product.product.name}, #{@news_product.news.title}")
  end

  private

  def initialize_news_product
    # will be an array if coming from chosen-rails multiple select dropdown
    if news_product_params[:product_id].is_a?(Array)
      @news_products = []
      news_id = news_product_params[:news_id]
      news_product_params[:product_id].reject(&:blank?).each do |product|
        @news_products << NewsProduct.new({news_id: news_id, product_id: product})
      end
    else
      @news_product = NewsProduct.new(news_product_params)
    end
  end

  def news_product_params
    params.require(:news_product).permit!
  end
end
