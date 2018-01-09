class Admin::NewsImagesController < AdminController
  before_action :load_news_article
  load_and_authorize_resource

  def new
    @news_image = NewsImage.new(news: @news)
  end

  def create
    @news_image.news = @news
    respond_to do |format|
      if @news_image.save
        format.html { redirect_to([:admin, @news], notice: 'News image was successfully created.') }
        format.xml  { render xml: @news_image, status: :created, location: @news_image }
        format.js # Not really applicable because the attachment can't be sent via AJAX
      else
        format.html { redirect_to([:admin, @news], notice: 'There was a problem creating the News Image.') }
        format.xml  { render xml: @product_attachment.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end
  end

  def show
  end

  def update
    respond_to do |format|
      if @news_image.update_attributes(news_image_params)
        format.html { redirect_to([:admin, @news], notice: 'News image was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @news_image.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end
  end

  def destroy
    @news_image.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @news]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def load_news_article
    @news = News.find(params[:news_id])
  end

  def news_image_params
    params.require(:news_image).permit!
  end

end
