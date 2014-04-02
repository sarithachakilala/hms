class OpPatientReturn < ActiveRecord::Base
	validates_presence_of :receipt_no, :patient_name, :return_amount
		has_many :opreturn_child, :dependent => :destroy
		accepts_nested_attributes_for :opreturn_child, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }	
		acts_as_reportable
		$key_data
	def store_key(key_value)
		$key_data=key_value
	end
	def return_key
		return $key_data
	end
	
end
