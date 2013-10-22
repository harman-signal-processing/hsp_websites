Paperclip::Attachment.default_options[:use_timestamp] = false

Paperclip.interpolates(:timestamp) do |attachment, style|
  attachment.instance_read(:updated_at).to_i  
end

Paperclip.interpolates(:asset_host) do |attachment, style|
  if HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host.present?
  	HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host
  end
end