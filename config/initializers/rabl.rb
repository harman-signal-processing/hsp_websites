Rabl.configure do |config|
  config.include_json_root = false
  config.cache_all_output = false #Rails.env.production?
  config.perform_caching = false #Rails.env.production?
  config.xml_options = { dasherize: true, skip_type: false }
end

