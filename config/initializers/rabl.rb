Rabl.configure do |config|
  config.include_json_root = false
  config.cache_all_output = Rails.env.production?
  config.perform_caching = Rails.env.production?
  config.xml_options = { dasherize: true, skip_type: false }
end

