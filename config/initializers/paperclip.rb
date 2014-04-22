require 'aws-sdk'

Paperclip::Attachment.default_options[:use_timestamp] = false

Paperclip.interpolates(:timestamp) do |attachment, style|
  attachment.instance_read(:updated_at).to_i  
end

Paperclip.interpolates(:asset_host) do |attachment, style|
  if HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host.present?
  	HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host
  end
end

# Amazon account 'hspwww' access keys:
c = YAML.load_file(File.join(Rails.root, 'config/s3.yml')).symbolize_keys
Rails.configuration.aws = ((c[Rails.env.to_sym]) ? c[Rails.env.to_sym] : c.first).symbolize_keys!
AWS.config(logger: Rails.logger)
AWS.config(Rails.configuration.aws)

# Cloudfront only seems to work with an S3 bucket OR some other source (not both).
# So, since cdn.harmanpro.com is setup as an alias of assets.harmanpro.com, we need
# a separate CDN for stuff in the S3 buckets...
S3_CLOUDFRONT = Rails.env.production? ? 'adn.harmanpro.com' : nil # 'd18nzrj3czoaty.cloudfront.net' # 

if Rails.env.production?
	Paperclip::Attachment.default_options.merge!({
    url: ':fog_public_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension",
    storage: :fog,
    fog_credentials: FOG_CREDENTIALS,
    fog_directory: ENV['FOG_PAPERCLIP_CONTAINER'],
    fog_public: true,
    fog_host: ENV['FOG_HOST_ALIAS']

	  # storage: :s3,
	  # bucket: Rails.configuration.aws[:bucket],
	  # s3_credentials: Rails.configuration.aws,
   #  s3_host_alias: S3_CLOUDFRONT,
   #  url: ':s3_alias_url',
   #  path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
else
	Paperclip::Attachment.default_options.merge!({
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
end

S3DirectUpload.config do |c|
  c.access_key_id = Rails.configuration.aws[:access_key_id]
  c.secret_access_key = Rails.configuration.aws[:secret_access_key]
  c.bucket = Rails.configuration.aws[:bucket]
end
