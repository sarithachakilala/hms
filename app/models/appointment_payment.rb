class AppointmentPayment < ActiveRecord::Base
	validates_presence_of :org_location, :org_code, :appt_type, :department, :consultant_id, :op_number, :consultant_fee, :bill_no11
	before_update :chage_consultant_id
	before_create :chage_consultant_id
	def chage_consultant_id
		if  self.consultant_id
			con_id=self.consultant_id.split(" - ")
			self.consultant_id=con_id[0]
			self.consultant_name=con_id[1]
		end
	end
end
