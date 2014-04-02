class Admission < ActiveRecord::Base
	validates_presence_of :admn_no, :org_code, :org_location, :mr_no, :registration_id, :consultant_id	
    validates_presence_of :patient_name, :with=>/^[A-Za-z].*\z/
	validates_presence_of :department, :room, :bed, :ward
	validates_presence_of :age, :gender, :consultant_id
	before_create :check_validation
	
	def check_validation

		return false if self.authorized_police_station.empty? || self.authorized_police_station.nil? if self.admn_type == "MLC" 
		return false if self.case_type.nil? || self.case_type.empty? if self.admn_type == "MLC" 
		return false if self.fir_no.nil? || self.fir_no.empty? if self.admn_type == "MLC" 
		return false if self.package_category.nil? || self.package_category.empty? if self.admn_category == "Package" 
		return false if self.sub_category.nil? || self.sub_category.empty? if self.admn_category == "Package" 
		return false if self.days.nil? || self.days.empty?  if self.admn_category == "Package" 
		return false if self.amount.nil? || self.amount.empty? if self.admn_category == "Package" 
	end
	
	def find_admn_no()
		@admission=Admission.last
		number_master=NumberMaster.last
		starting_string_admn_no=number_master.ip_no
		str=""
		 if(@admission)
			admn_no=starting_string_admn_no+number_master.ip_no_length
			starting_string_admn_no<<@admission.admn_no.slice!(starting_string_admn_no.length..admn_no.length).next
			return starting_string_admn_no
		else
			starting_string_admn_no<<number_master.ip_no_length<<number_master.ip_suffix
			return starting_string_admn_no
		end
	end
	
end
