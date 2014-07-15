require 'aws-sdk'

# Disable content spoofing detector which is really buggy as of 6/2014
require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

# Don't use the timestamp in the generated URLs
Paperclip::Attachment.default_options[:use_timestamp] = false

# Add support for timestamps in the stored file path
Paperclip.interpolates(:timestamp) do |attachment, style|
  attachment.instance_read(:updated_at).to_i  
end

# Add support for the asset host in the interpolated URL path
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
S3_CLOUDFRONT = 'adn.harmanpro.com' # 'd18nzrj3czoaty.cloudfront.net' # 

# Environment-specific settings:
#if Rails.env.production?

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

  S3_STORAGE = {
    storage: :s3,
    bucket: Rails.configuration.aws[:bucket],
    s3_credentials: Rails.configuration.aws,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
  }
# else
  
# 	Paperclip::Attachment.default_options.merge!({
#     url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
#     storage: :filesystem,
#     path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
# 	})

#   S3_STORAGE = {
#     url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
#     storage: :filesystem,
#     path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"    
#   }
# end

# This can go away after merging the new dbx look back into the master branch. Needed for staging/dev
# without messing up the S3 stored slides, etc., but don't forget to edit the setting.rb model
if Rails.env.production?
  SETTINGS_STORAGE = S3_STORAGE
else
  SETTINGS_STORAGE = {
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    storage: :filesystem,
    path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"    
  }
end

# Setting up S3 Direct upload for large file uploads...
S3DirectUpload.config do |c|
  c.access_key_id = Rails.configuration.aws[:access_key_id]
  c.secret_access_key = Rails.configuration.aws[:secret_access_key]
  c.bucket = Rails.configuration.aws[:bucket]
end
