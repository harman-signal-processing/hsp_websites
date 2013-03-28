class RsoSetting < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.setting_types
    ["string", "integer", "text", "html"]
  end

  def self.invitation_code
    HarmanSignalProcessingWebsite::Application.config.rso_invitation_code
  end

  # Determines the value of the current Setting. Values can come
  # from the string, text, integer, or slide attachment. 
  def value
    begin
      eval("self.#{self.setting_type}_value")
    rescue
      nil
    end
  end
  
  def self.value_for(key)
    begin
      where(name: key).first.value
    rescue
      nil
    end
  end
  
end
