# Initializers for old-style vendor/plugins

# I18n hierarchy helper
require File.expand_path(Rails.root.join("lib", "i18n_translation_helper"))
I18n.send :include, I18nTranslationHelper
