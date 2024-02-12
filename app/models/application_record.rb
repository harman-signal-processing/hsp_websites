class ApplicationRecord < ActiveRecord::Base
  include SqlDumper

  self.abstract_class = true

  # Whitelisting everything for ransack (same as ransack before 4.0)
  def self.ransackable_attributes(auth_object = nil)
    column_names + _ransackers.keys
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end

end
