AssetSync.configure do |config|
  config.run_on_precompile = true # if true, runs automatically after assets:precompile
  config.fog_provider = 'Rackspace'
  config.fog_directory = ENV['ASSET_CONTAINER']
  config.fog_region = 'ORD'
  config.rackspace_username = ENV['RACKSPACE_USERNAME']
  config.rackspace_api_key = ENV['RACKSPACE_API_KEY']

  # Invalidate a file on a cdn after uploading files
  # config.cdn_distribution_id = "12345"
  # config.invalidate = ['file1.js']
  #
  # Don't delete files from the store
  # config.existing_remote_files = "keep"
  #
  # Automatically replace files with their equivalent gzip compressed version
  # config.gzip_compression = true
  #
  # Use the Rails generated 'manifest.yml' file to produce the list of files to
  # upload instead of searching the assets directory.
  config.manifest = true
  
  # Fail silently.  Useful for environments such as Heroku
  # config.fail_silently = true

  config.custom_headers = {
    ".*\.eot" => { :access_control_allow_origin => "*" },
    ".*\.svg" => { :access_control_allow_origin => "*" },
    ".*\.ttf" => { :access_control_allow_origin => "*" },
    ".*\.woff" => { :access_control_allow_origin => "*" },
  }

end
