class Admin::ScheduledTasksController < AdminController
  before_action :initialize_scheduled_task, only: :create
  load_and_authorize_resource

  # GET /scheduled_tasks
  # GET /scheduled_tasks.xml
  def index
    @scheduled_tasks = ScheduledTask.where("perform_at > ?", Time.now).order("perform_at ASC")
    @recent_tasks = ScheduledTask.where("perform_at < ? ", Time.now).order("perform_at DESC").limit(50)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @scheduled_tasks }
    end
  end

  # GET /scheduled_tasks/1
  # GET /scheduled_tasks/1.xml
  def show
    @scheduled_task_action = ScheduledTaskAction.new(scheduled_task: @scheduled_task)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @scheduled_task }
    end
  end

  def value_field
    @scheduled_task_action = ScheduledTaskAction.new(scheduled_task: @scheduled_task, field_name: params[:field_name])

    respond_to do |format|
      format.js
    end
  end

  def run
    respond_to do |format|
      if @scheduled_task.run!
        @scheduled_task.update(perform_at: 1.minute.ago)
        format.html { redirect_to([:admin, @scheduled_task], notice: "The task was run. See the results below. The task is no longer scheduled to run again.") }
      else
        format.html { redirect_to([:admin, @scheduled_task], alert: "Something went wrong.") }
      end
    end
  end

  # GET /scheduled_tasks/new
  # GET /scheduled_tasks/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @scheduled_task }
    end
  end

  # GET /scheduled_tasks/1/edit
  def edit
    @scheduled_task.scheduled_task_actions.build
  end

  # POST /scheduled_tasks
  # POST /scheduled_tasks.xml
  def create
    respond_to do |format|
      if @scheduled_task.save
        format.html { redirect_to([:admin, @scheduled_task], notice: 'Scheduled Task was successfully created.') }
        format.xml  { render xml: @scheduled_task, status: :created, location: @scheduled_task }
        website.add_log(user: current_user, action: "Created scheduled task: #{@scheduled_task.id}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @scheduled_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scheduled_tasks/1
  # PUT /scheduled_tasks/1.xml
  def update
    respond_to do |format|
      if @scheduled_task.update(scheduled_task_params)
        format.html { redirect_to([:admin, @scheduled_task], notice: 'Scheduled Task was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated scheduled task: #{@scheduled_task.id}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @scheduled_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduled_tasks/1
  # DELETE /scheduled_tasks/1.xml
  def destroy
    @scheduled_task.destroy
    respond_to do |format|
      format.html { redirect_to(admin_scheduled_tasks_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted scheduled task: #{@scheduled_task.id}")
  end

  private

  def initialize_scheduled_task
    @scheduled_task = ScheduledTask.new(scheduled_task_params)
  end

  def scheduled_task_params
    params.require(:scheduled_task).permit(:perform_at, :schedulable_type, :schedulable_friendly_id, :status)
  end
end