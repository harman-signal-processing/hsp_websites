# coding: utf-8

I18n.default_locale = 'en'

LOCALES_DIRECTORY = Rails.root.join("config", "locales")

LANGUAGES = {
  "English" => 'en',
  "中国" => 'zh-CN',
  "Português (Brasil)" => 'pt-BR',
}

# Not really used anymore...these come from the inidividual Websites'
# configuration
AVAILABLE_LOCALES = [I18n.default_locale, "en-US"]

# Used for the admin interface to add translations before they're
# listed in the "AVAILABLE_LOCALES"
ALL_LOCALES = AVAILABLE_LOCALES + ["es", "de", "nl", "zh", "pt-BR"]

