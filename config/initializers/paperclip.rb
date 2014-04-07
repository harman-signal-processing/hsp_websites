Paperclip::Attachment.default_options[:use_timestamp] = false

Paperclip.interpolates(:timestamp) do |attachment, style|
  attachment.instance_read(:updated_at).to_i  
end

Paperclip.interpolates(:asset_host) do |attachment, style|
  if HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host.present?
  	HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host
  end
end

# if Rails.env.production?
	Paperclip::Attachment.default_options.merge!({
    url: ':public_url',
    path: ":attachment/:id_:timestamp/:basename_:style.:extension",
    storage: :fog,
    fog_credentials: FOG_CREDENTIALS,
    fog_directory: ENV['FOG_PAPERCLIP_CONTAINER'],
    fog_public: true

	  # storage: :s3,
	  # bucket: S3_CREDENTIALS['bucket'],
	  # s3_credentials: S3_CREDENTIALS,
   #  s3_host_alias: S3_CLOUDFRONT,
   #  url: ':s3_alias_url',
   #  path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
	})
# else
# 	Paperclip::Attachment.default_options.merge!({
#     url: '/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
#     path: ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
# 	})
# end
