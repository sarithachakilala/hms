class Registration < ActiveRecord::Base
	validates_presence_of :age, :gender, :mr_no, :reg_no, :reg_date, :patient_name, :age_in, :martial_status, :father_name, :city, :state, :country, :address
	validates_numericality_of :age
	
	before_save :check_validation

	def check_validation

		return false if self.referral_name.nil? || self.referral_name.empty? if self.referral == "Referral" and self.reg_type == "General"
		return false if self.referral_contact_no.nil? || self.referral_contact_no.empty? if self.referral == "Referral" and self.reg_type == "General"
		return false if self.name.nil? || self.name.empty? if self.referral == "Other" and self.reg_type == "General"
		return false if self.ph_no1.nil? || self.ph_no1.empty? if self.referral == "Other" and self.reg_type == "General"
		
		return false if self.ins_company_name.empty? || self.ins_company_name.nil?  if self.reg_type == "Insurance"
		return false if self.policy_no.nil? || self.policy_no.empty? if self.reg_type == "Insurance"
		return false if self.relation_to_insurence.nil?||self.relation_to_insurence.empty? if self.reg_type == "Insurance"
		return false if self.plan_name.nil? || self.plan_name.empty? if self.reg_type == "Insurance"
		return false if self.arogyasree_card_no.nil? || self.arogyasree_card_no.empty? if self.reg_type == "Arogyasree"
	
	end
	

	def find_mr_no()
		@registration=Registration.last
		number_master=NumberMaster.last
		starting_string_mr=number_master.mr_no
		starting_string_reg=number_master.reg_no
		str=""
		if(@registration)
			mr=starting_string_mr+number_master.mr_no_length
			reg=starting_string_reg+number_master.reg_no_length
			starting_string_mr<<@registration.mr_no.slice!(starting_string_mr.length..mr.length).next
			starting_string_reg<<@registration.reg_no.slice!(starting_string_reg.length..reg.length).next
			return starting_string_mr,starting_string_reg
		else
			starting_string_mr<<number_master.mr_no_length.to_s<<number_master.mr_suffix.to_s
			starting_string_reg<<number_master.reg_no_length.to_s<<number_master.reg_suffix.to_s
			return starting_string_mr,starting_string_reg
		end
	end
	before_create :set_filename
	after_create :store_file 

	before_update :set_filename
	after_update :store_file 

	attr_accessor :uploaded_file
	attr_accessor :filename
	
	def store_file 
		if(uploaded_file)
			File.open(file_storage_location, 'wb') do |f| 
				f.write uploaded_file.read 
			end
		end
	end
	
	def file_storage_location 
		directory_name = 'public/patient_photos/'+Date.today.strftime("%d.%m.%Y").to_s
		if(!File.exists? directory_name)
			Dir.mkdir( "public/patient_photos/"+Date.today.strftime("%d.%m.%Y").to_s, 755 )
		end
		filename = uploaded_file.original_filename
		File.join(Rails.root, 'public/patient_photos/'+Date.today.strftime("%d.%m.%Y").to_s, filename)
	end
	
	def set_filename 
		if(uploaded_file)
			filename = uploaded_file.original_filename
		end
	end
	
	$key_data
	def store_key(key_value)
		$key_data=key_value
	end
	def return_key
		return $key_data
	end
	
end
