module Admin::SettingsHelper

  def value_for(setting)
    if setting.value.is_a?(Paperclip::Attachment)
      link_name = setting.slide_file_name.to_s.match(/png|jpg|gif|jpeg/i) ?
        image_tag(setting.slide.url(:medium)) : setting.slide_file_name
      link_to(link_name, setting.slide.url)
    else
      setting.value
    end
  end

  def user_locale_options(user, website)
    opts = website.website_locales
    if user.roles.include?("translator")
      opts = opts.where(locale: user.locales)
    end
    opts.map{|l| [l.name, l.locale]}
  end

end
