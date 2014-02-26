
# Amazon account 'hspwww' access keys:
c = YAML.load_file(File.join(Rails.root, 'config/s3.yml')).symbolize_keys

S3_CREDENTIALS = (c[Rails.env.to_sym]) ? c[Rails.env.to_sym] : c.first

# Cloudfront only seems to work with an S3 bucket OR some other source (not both).
# So, since cdn.harmanpro.com is setup as an alias of assets.harmanpro.com, we need
# a separate CDN for stuff in the S3 buckets...

S3_CLOUDFRONT = 'adn.harmanpro.com' # 'd18nzrj3czoaty.cloudfront.net' # 

if Rails.env.production?
	Paperclip::Attachment.default_options.merge!({
	  storage: :s3,
	  bucket: S3_CREDENTIALS['bucket'],
	  s3_credentials: S3_CREDENTIALS,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
else
	Paperclip::Attachment.default_options.merge!({
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
end