# Disable content spoofing detector which is really buggy as of 6/2014
require 'paperclip/media_type_spoof_detector'
require 'addressable'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
  class UrlGenerator
    private
    def escape_url(url)
      if url.respond_to?(:escape)
        url.escape
      else
        Addressable::URI.parse(url).normalize.to_str.gsub(escape_regex){|m| "%#{m.ord.to_s(16).upcase}" }
      end
    end
  end
end

Paperclip::UriAdapter.register
Paperclip::HttpUrlProxyAdapter.register

Paperclip::Attachment.default_options[:compression] = {
  png: "-o 5 -quiet",
  jpeg: "-copy none -optimize -progressive"
}

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
#Aws.config(logger: Rails.logger)
#Aws.config(Rails.configuration.aws)

# Cloudfront only seems to work with an S3 bucket OR some other source (not both).
# So, since cdn.harmanpro.com is setup as an alias of assets.harmanpro.com, we need
# a separate CDN for stuff in the S3 buckets...
S3_CLOUDFRONT = 'adn.harmanpro.com' # 'd18nzrj3czoaty.cloudfront.net' #

# Environment-specific settings:
if Rails.env.production? || !!(ENV['USE_PRODUCTION_ASSETS'].to_i > 0)

	# Allow Paperclip to get image from S3 url
  Paperclip::UriAdapter.register

  S3_STORAGE = {
    storage: :s3,
    bucket: Rails.configuration.aws[:bucket],
    s3_credentials: Rails.configuration.aws,
    s3_host_alias: S3_CLOUDFRONT,
    s3_protocol: 'https',
    s3_region: ENV['AWS_REGION'],
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
  }
  
	Paperclip::Attachment.default_options.merge!(S3_STORAGE)
	
elsif Rails.env.test?

	Paperclip::Attachment.default_options.merge!({
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    storage: :filesystem,
    path: ":rails_root/spec/test_files/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})

  S3_STORAGE = {
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    storage: :filesystem,
    path: ":rails_root/spec/test_files/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
  }

else

	Paperclip::Attachment.default_options.merge!({
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    storage: :filesystem,
    path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})

  S3_STORAGE = {
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    storage: :filesystem,
    path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
  }
  
end

if Rails.env.production? || !!(ENV['USE_PRODUCTION_ASSETS'].to_i > 0)
  SETTINGS_STORAGE = S3_STORAGE
elsif Rails.env.test?
  SETTINGS_STORAGE = {
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    storage: :filesystem,
    path: ":rails_root/spec/test_files/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
  }
else
  SETTINGS_STORAGE = {
    url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    storage: :filesystem,
    path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
  }
end

# Setting up S3 Direct upload for large file uploads...
S3DirectUpload.config do |config|
  config.access_key_id = Rails.configuration.aws[:access_key_id]
  config.secret_access_key = Rails.configuration.aws[:secret_access_key]
  config.region = ENV['AWS_REGION']
  config.bucket = Rails.configuration.aws[:bucket]
  config.url = "https://#{config.bucket}.s3.amazonaws.com/"
end
Aws.config.update({
  credentials: Aws::Credentials.new(Rails.configuration.aws[:access_key_id], Rails.configuration.aws[:secret_access_key])
})
