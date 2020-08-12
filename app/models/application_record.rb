class ApplicationRecord < ActiveRecord::Base
  include SqlDumper

  self.abstract_class = true
end
