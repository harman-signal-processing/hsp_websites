require 'googleauth'
require 'google/apis/analyticsreporting_v4'

module StatsServiceV4
 def self.get_access_token
    scopes = ['https://www.googleapis.com/auth/analytics','https://www.googleapis.com/auth/analytics.readonly']
    puts "StatsServiceV4 called"
    authorization = Google::Auth.get_application_default(scopes)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = authorization
    access_token = analytics.authorization.fetch_access_token!
    access_token["access_token"]
 end
end  #  module StatsServiceV4