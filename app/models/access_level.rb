# AccessLevel is used by SiteElements to allow read access to
# certain elements. The Ability class which is part of CanCan
# sets up the actual authorization. It just uses AccessLevels
# so we can assign different roles access to elements. In order
# for this it to pass, the User must have at least one role
# that matches the AccessLevel role(s).
#
# Also, at this point there is no admin tool to manage AccessLevels.
# Just create them from the rails console if needed.
#
class AccessLevel < ApplicationRecord

  validates :name, presence: true

  # The roles are automatically selected as all the boolean
  # columns in the AccessLevel table...
  class << self
    def roles
      columns.select{|c| c if c.type == :boolean}.map{|c| c.name}
    end
  end

  def readable_by?(user)
    self.class.roles.each do |role|
      return true if send("#{role}_access?", user)
    end
    false
  end

  AccessLevel.roles.each do |role|
    define_method("#{role}_access?") do |user|
      user.send("#{role}?") && send("#{role}?")
    end
  end

  def long_name
    "#{name} (#{enabled_roles.map{|r| r}.join(', ')})"
  end

  def enabled_roles
    @enabled_roles ||= self.class.roles.select do |role|
      role if send("#{role}?")
    end
  end

end
