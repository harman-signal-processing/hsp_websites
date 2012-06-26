class Admin::RepQuestionsController < AdminController
  load_and_authorize_resource
  # GET /rep_questions
  # GET /rep_questions.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rep_questions }
    end
  end

  # GET /rep_questions/1
  # GET /rep_questions/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rep_question }
    end
  end

  # GET /rep_questions/new
  # GET /rep_questions/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rep_question }
    end
  end

  # GET /rep_questions/1/edit
  def edit
  end

  # POST /rep_questions
  # POST /rep_questions.xml
  def create
    respond_to do |format|
      if @rep_question.save
        format.html { redirect_to([:admin, @rep_question], :notice => 'Rep question was successfully created.') }
        format.xml  { render :xml => @rep_question, :status => :created, :location => @rep_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rep_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rep_questions/1
  # PUT /rep_questions/1.xml
  def update
    respond_to do |format|
      if @rep_question.update_attributes(params[:rep_question])
        format.html { redirect_to([:admin, @rep_question], :notice => 'Rep question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rep_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rep_questions/1
  # DELETE /rep_questions/1.xml
  def destroy
    @rep_question.destroy
    respond_to do |format|
      format.html { redirect_to(admin_rep_questions_url) }
      format.xml  { head :ok }
    end
  end

end
