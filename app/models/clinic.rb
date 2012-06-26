class Clinic < ActiveRecord::Base
  belongs_to :clinician, :class_name => "User", :foreign_key => "clinician_id"
  belongs_to :rep, :class_name => "User", :foreign_key => "rep_id"
  has_many :clinic_products, :inverse_of => :clinic
  has_many :products, :through => :clinic_products
  has_one :clinician_report
  has_one :rep_report
  has_many :clinician_questions, :through => :clinician_reports
  has_many :rep_questions, :through => :rep_reports
  belongs_to :dealer
  belongs_to :brand
  accepts_nested_attributes_for :clinic_products, :reject_if => :all_blank
  validates :dealer_id, :presence => {:unless => "location", :message => "You must provide a dealer id or a location" }
  
end
