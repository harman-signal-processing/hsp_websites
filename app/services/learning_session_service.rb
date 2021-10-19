module LearningSessionService
  def self.get_learning_session_data(brand_name)
      url = "#{ENV['PRO_SITE_URL']}/api/v1/learning_sessions/#{brand_name}"
      encoded_url = URI.encode(url)
      response = HTTParty.get(encoded_url, ssl_version: :TLSv1_2)
      if response.success?
        result = response.deep_symbolize_keys
        result
      else
        raise response.message
      end
  end  #  self.get_learning_session_data  
end  #  module LearningSessionService