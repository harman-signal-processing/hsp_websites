module Admin::SettingsHelper
  
  def value_for(setting)
    (setting.value.is_a?(Paperclip::Attachment)) ? link_to(setting.slide_file_name, setting.slide.url) : setting.value
  end
  
end
