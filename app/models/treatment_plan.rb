class TreatmentPlan < ActiveRecord::Base
	has_many :medicine_list, :dependent => :destroy
	accepts_nested_attributes_for :medicine_list , :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { attrs[:name].blank? } }	
	validates_presence_of  :patient_type, :org_code, :org_location, :mr_no, :registration_id
end
