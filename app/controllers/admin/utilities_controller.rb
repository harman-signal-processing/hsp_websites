class Admin::UtilitiesController < AdminController
  skip_authorization_check

  def index
  end

  def flush_cache
    results = {}
    if Rails.env.production?
      if ENV['REDIS_URL'].present?
        res = Redis.new(url: ENV['REDIS_URL']).flushall
        results[:notice] = "Redis flush at #{ENV['REDIS_URL']} response: #{res}."
      else
        Rails.cache.clear
        results[:notice] = "Rails cache is cleared."
      end
    else
      results[:alert] = "Cache can only be cleared in production environment."
    end
    redirect_to admin_utilities_path, results and return false
  end

end
