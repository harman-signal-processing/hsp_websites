class Admin::BadActorLogsController < AdminController
  before_action :initialize_bad_actor_log, only: :create
  load_and_authorize_resource

  # Just a quick view of recent bad activity. Needs more work.
  def index
    load_bad_actor_logs_for_index
    @bad_actor_log = BadActorLog.new(created_at: Time.now)
    respond_to do |format|
      format.html
      format.txt
    end
  end

  def show
    render plain: @bad_actor_log.details
  end

  def create
    respond_to do |format|
      if @bad_actor_log.save
        log_bad_actors(@bad_actor_log.ip_address, @bad_actor_log.reason)
        format.html { redirect_to(admin_bad_actor_logs_url, notice: 'BadActorLog was successfully created.') }
      else
        format.html {
          load_bad_actor_logs_for_index
          render action: "index"
        }
      end
    end
  end

  # for removing false-positives
  def destroy
    @bad_actor_log.destroy
    respond_to do |format|
      format.html { redirect_to(admin_bad_actor_logs_url) }
      format.js
    end
  end

  private

  def log_bad_actors(ip_address, reason)
    logger = ActiveSupport::Logger.new("log/brandsite_bad_actor.log")
    time = Time.now
    formatted_datetime = time.strftime('%Y-%m-%d %I:%M:%S %p')
    logger.error "#{ ip_address } - - [#{formatted_datetime}] \"#{ reason }\" ~~ Admin entered for #{website.url}"
  end

  def load_bad_actor_logs_for_index
    @days = params[:days] || "30"
    @bad_actor_logs = BadActorLog.where("created_at >= ?", @days.to_i.days.ago).order("created_at DESC")
  end

  def initialize_bad_actor_log
    @bad_actor_log = BadActorLog.new(bad_actor_log_params)
  end

  def bad_actor_log_params
    params.require(:bad_actor_log).permit(
      :created_at,
      :ip_address,
      :reason,
      :details
    )
  end

end
