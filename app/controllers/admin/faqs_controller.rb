class Admin::FaqsController < AdminController
  before_filter :initialize_faq, only: :create
  load_and_authorize_resource except: :index
  # GET /faqs
  # GET /faqs.xml
  def index
    if params[:q]
      @search = Faq.ransack(params[:q])
      @faqs = @search.result.order(:question)
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @faqs }
    end
  end

  # GET /faqs/1
  # GET /faqs/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @faq }
    end
  end

  # GET /faqs/new
  # GET /faqs/new.xml
  def new
    if params[:product_id]
      @faq.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @faq }
    end
  end

  # GET /faqs/1/edit
  def edit
  end

  # POST /faqs
  # POST /faqs.xml
  def create
    respond_to do |format|
      if @faq.save
        format.html { redirect_to([:admin, @faq], notice: 'Question was successfully created.') }
        format.xml  { render xml: @faq, status: :created, location: @faq }
        website.add_log(user: current_user, action: "Created FAQ: #{@faq.question}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @faq.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /faqs/1
  # PUT /faqs/1.xml
  def update
    respond_to do |format|
      if @faq.update_attributes(faq_params)
        format.html { redirect_to([:admin, @faq], notice: 'Question was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated FAQ: #{@faq.question}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @faq.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faqs/1
  # DELETE /faqs/1.xml
  def destroy
    @faq.destroy
    respond_to do |format|
      format.html { redirect_to(admin_faqs_url, notice: "The question was deleted.") }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted FAQ: #{@faq.question}")
  end

  private

  def initialize_faq
    @faq = Faq.new(faq_params)
  end

  def faq_params
    params.require(:faq).permit!
  end
end
