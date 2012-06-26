class RsoSetting < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.setting_types
    ["string", "integer", "text", "html"]
  end

  def self.invitation_code
    if Rails.env.production? || Rails.env.staging?
      value_for("invitation_code") || "FLSKWERCVIERUW"
    else
      "INVITED"
    end
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
      where(:name => key).first.value
    rescue
      nil
    end
  end
  
end
