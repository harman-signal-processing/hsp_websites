require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('geocodio_api_key') { ENV['GEOCODIO_API_KEY'] }
  c.filter_sensitive_data('adyen_api_key') { ENV['ADYEN_API_KEY'] }
  c.filter_sensitive_data('adyen_client_key') { ENV['ADYEN_CLIENT_KEY'] }
  c.filter_sensitive_data('adyen_merchant_account') { ENV['ADYEN_MERCHANT_ACCOUNT'] }
  c.ignore_localhost = true
  c.configure_rspec_metadata!
end
