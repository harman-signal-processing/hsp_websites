class Admin::ScheduledTaskActionsController < AdminController
  before_action :initialize_scheduled_task_action, only: :create
  load_and_authorize_resource
  
  # GET /scheduled_task_actions
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
    end
  end

  # GET /scheduled_task_actions/1
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
    end
  end
  
  # GET /scheduled_task_actions/new
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
    end
  end

  # GET /scheduled_task_actions/1/edit
  def edit
  end

  # POST /scheduled_task_actions
  def create
    respond_to do |format|
      if @scheduled_task_action.save
        format.html { redirect_to([:admin, @scheduled_task_action.scheduled_task], notice: 'Scheduled Task Action was successfully created.') }
        website.add_log(user: current_user, action: "Created scheduled task action: #{@scheduled_task_action.id}")
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /scheduled_task_actions/1
  def update
    respond_to do |format|
      if @scheduled_task_action.update(scheduled_task_action_params)
        format.html { redirect_to([:admin, @scheduled_task_action.scheduled_task], notice: 'Scheduled Task Action was successfully updated.') }
        website.add_log(user: current_user, action: "Updated scheduled task action: #{@scheduled_task_action.id}")
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /scheduled_task_actions/1
  def destroy
    @scheduled_task_action.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @scheduled_task_action.scheduled_task]) }
    end
    website.add_log(user: current_user, action: "Deleted scheduled task action: #{@scheduled_task_action.id}")
  end

  private

  def initialize_scheduled_task_action
    @scheduled_task_action = ScheduledTaskAction.new(scheduled_task_action_params)
  end

  def scheduled_task_action_params
    params.require(:scheduled_task_action).permit(:scheduled_task_id, :field_type, :field_name,
      :new_integer_value, :new_text_value, :new_string_value, :new_boolean_value,
      :new_date_value, :new_datetime_value)
  end
end