class OperatingSystem < ActiveRecord::Base
  attr_accessible :arch, :name, :version
  has_many :software_operating_systems, dependent: :destroy
  has_many :softwares, through: :software_operating_systems

  validates :name, presence: true

  def formatted_name
  	fields = [name]
  	fields << version if version.present?
  	fields << arch if arch.present?
  	fields.join(" ")
  end
end
