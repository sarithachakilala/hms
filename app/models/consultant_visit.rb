class ConsultantVisit < ActiveRecord::Base
	validates_presence_of :patient_name, :with=>/^[A-Za-z.]*\z/
	validates_presence_of :org_code, :with=>/^[A-Za-z.]*\z/
	validates_presence_of :org_location, :with=>/^[A-Za-z.]*\z/
	validates_presence_of :admn_no
	validates_presence_of :mr_no, :department
	
	has_many :consultant_visit_children, :dependent => :destroy
	accepts_nested_attributes_for :consultant_visit_children, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }	

	before_update :check_name

	def check_name
		self.patient_name=Number.new.change_patient_name(self.patient_name)
	end

end
