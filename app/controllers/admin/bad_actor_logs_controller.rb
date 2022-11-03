class Admin::BadActorLogsController < AdminController
  load_and_authorize_resource

  # Just a quick view of recent bad activity. Needs more work.
  def index
    @bad_actor_logs = BadActorLog.order("created_at DESC").limit(100)
  end

  def show
    render plain: @bad_actor_log.details
  end

  # for removing false-positives
  def destroy
    @bad_actor_log.destroy
    respond_to do |format|
      format.html { redirect_to(admin_bad_actor_logs_url) }
      format.js
    end
  end
end
