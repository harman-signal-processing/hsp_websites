
# Amazon account 'hspwww' access keys:
c = YAML.load_file(File.join(Rails.root, 'config/s3.yml')).symbolize_keys

S3_CREDENTIALS = (c[Rails.env.to_sym]) ? c[Rails.env.to_sym] : c.first

# if Rails.env == "production"
#   # set credentials from ENV hash
#   S3_CREDENTIALS = { :access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET'], :bucket => "bucketname"}
# else
#   # get credentials from YML file
#   S3_CREDENTIALS = Rails.root.join("config/s3.yml")
# end