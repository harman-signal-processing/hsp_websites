
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


# Cloudfront only seems to work with an S3 bucket OR some other source (not both).
# So, since cdn.harmanpro.com is setup as an alias of assets.harmanpro.com, we need
# a separate CDN for stuff in the S3 buckets...

S3_CLOUDFRONT = 'd18nzrj3czoaty.cloudfront.net' # 'adn.harmanpro.com' # (requested from IT on 10/29)

# if Rails.env.production?
	Paperclip::Attachment.default_options.merge!({
	  storage: :s3,
	  bucket: S3_CREDENTIALS['bucket'],
	  s3_credentials: S3_CREDENTIALS,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
# else
# 	Paperclip::Attachment.default_options.merge!({
#     url: '/system/:attachment/:id_:timestamp/:basename_:style.:extension',
#     path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
# 	})
# end